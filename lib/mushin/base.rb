require_relative './middleware/builder'
require_relative './middleware/runner'

module Mushin 
  module Errors  
    exceptions = %w[ UnkownDSLConstruct UnkownActivation UnknownOption ]  
    exceptions.each { |e| const_set(e, Class.new(StandardError)) }  
  end

  module Customization 
    class << self
      def opts
	instance_eval do 
	  @opts ||= {}
	end
      end
      def params
	instance_eval do 
	  @params ||= {}
	end
      end
    end
    module Opts
      def self.[] key 
	Mushin::Customization.opts[key] 
      end
      def self.[]= key, value
	Mushin::Customization.opts.merge! Hash[key, value]
      end
    end
    module Params
      def self.[] key 
	Mushin::Customization.params[key] 
      end
      def self.[]= key, value
	Mushin::Customization.params.merge! Hash[key, value]
      end
    end
  end

  module DSL
    class Context
      attr_accessor :title, :statments
      def initialize title
	@title = title
	@statments = []
      end
    end
    class Statment 
      attr_accessor :title, :activations
      def initialize title 
	@title = title
	@activations = []
      end
    end
    class Activation 
      attr_accessor :name, :opts, :params
      def initialize name, opts={}, params={} 
	@name = name 
	@opts = opts
	@params = params
      end
    end

    module Notebook
      def self.extended(mod)
	puts "#{self} extended in #{mod}"
	#self.send(:include, mod)
	mod.send(:include, self)
      end

      def self.build context_construct, statment_construct, activation_construct
	@@statment_construct = statment_construct
	@@activation_construct = activation_construct
	@@contexts = []
	def context title, &block
	  @context = Mushin::DSL::Context.new title
	  def statment statment=[], &block
	    @statment = Mushin::DSL::Statment.new statment 

	    def activation name, opts={}, params={}
	      @activation = Mushin::DSL::Activation.new name, opts, params
	      @statment.activations << @activation 
	    end
	    #Mushin::DSL::Notebook.class_eval do 
	    Mushin::DSL::Notebook.instance_eval do 
	      alias_method @@activation_construct, :activation 
	    end
	    yield
	    @context.statments << @statment
	    @statment = nil 
	  end
	  #Mushin::DSL::Notebook.class_eval do 
	  Mushin::DSL::Notebook.instance_eval do 
	    alias_method @@statment_construct, :statment 
	  end
	  yield
	  @@contexts << @context
	  @context = nil 
	end
	alias_method context_construct, :context 
      end

      def self.find activity_context, activity_statment
	@@middlewares = []
	@@contexts.each do |current_context|
	  if activity_context == current_context.title
	    current_context.statments.each do |statment|
	      if activity_statment == statment.title
		statment.activations.each do |middleware|
		  @@middlewares << middleware 
		end
	      end
	    end
	  end
	end
	@@middlewares
      end
    end
  end

  class Env
    @@ds = ''

    def Env.register &block
      class_eval &block
    end

    #def Env.params &block
    #attr_accessor :opts, :params
    #instance_eval &block
    #end

    #def Env.set id, &block 
    #  raise "Framework didn't implement Env.set" 
    #end
    @@domain_folder = ""
    def Env.set id, &block 
      @id = id
      def self.on domain_context, &block
	@@domain_context = domain_context 
	@@activities = []  
	def self.activity statment 
	  @@activities += [statment]                                                                          
	end
	class_eval(&block)
      end
      class_eval(&block)

      Dir["./#{@@domain_folder}/*"].each {|file| load file }  

      Mushin::Engine.setup [Object.const_get(@@ds)]
      @@activities.each do |activity| 
	Mushin::Engine.run @@domain_context, activity   
      end
    end

    def Env.get id
      raise "Framework didn't implement Env.get" 
    end
  end

  module Engine
    def Engine.setup before_stack = [] 
      @@setup_middlewares = before_stack
    end

    def Engine.run domain_context, activity
      @@domain_context = domain_context
      @@activity = activity

      @@middlewares = Mushin::DSL::Notebook.find @@domain_context, @@activity 
      @@stack = Middleware::Builder.new do
	@@middlewares.each do |middleware|
	  #p "use #{middleware.name}, #{middleware.opts}, #{middleware.params}"
	  use middleware.name, middleware.opts, middleware.params
	end
      end
      @@setup_middlewares.each do |setup_middleware|
	@@stack.insert_before 0, setup_middleware 
      end
      @@stack.call
    end
  end
end
