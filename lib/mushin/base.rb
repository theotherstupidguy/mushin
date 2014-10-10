module Mushin # Domain Frameworks Generator
  module Errors  
    exceptions = %w[ UnkownDSLConstruct UnkownUse UnknownOption ]  
    exceptions.each { |e| const_set(e, Class.new(StandardError)) }  
  end

  module Env
    def register &block
      module_eval &block
    end

    def set id, &block
      raise "Domain Framework must impelment set"
    end
    def get id
      raise "Domain Framework must impelment get"
    end
  end
  module Domain
    module Mushin::Domain::Middleware 
      class << self
	attr_accessor :opts, :params
	def opts
	  @opts ||= {}
	end
	def params
	  @params ||= {}
	end
      end
      module Opts
	def self.[] key 
	  Mushin::Domain::Middleware.opts[key] 
	end
	def self.[]= key, value
	  Mushin::Domain::Middleware.opts.merge! Hash[key, value]
	end
      end
      module Params
	def self.[] key 
	  Mushin::Domain::Middleware.params[key] 
	end
	def self.[]= key, value
	  Mushin::Domain::Middleware.params.merge! Hash[key, value]
	end
      end
    end
  end

  module DSL
    class Context
      attr_accessor :title, :activities
      def initialize title
	@title = title
	@activities = []
      end
    end
    class Activity 
      attr_accessor :title, :uses
      def initialize title 
	@title = title
	@uses = []
      end
    end
    class Use 
      attr_accessor :name, :opts, :params
      def initialize name, opts={}, params={} 
	@name = name 
	@opts = opts
	@params = params
      end
    end

    class << self
      attr_accessor :contexts, :middlewares
    end
    Mushin::DSL.contexts = []
    def context title, &block
      @context = Mushin::DSL::Context.new title 
      def activity activity=[], &block
	@activity = Mushin::DSL::Activity.new activity 
	def use name, opts={}, params={}
	  if !@activity.uses.bsearch {|x| x == [name,opts,params]}
	    @use = Mushin::DSL::Use.new name, opts, params
	    @activity.uses << @use
	  end
	end
	yield
	@context.activities << @activity
      end
      yield
     Mushin::DSL.contexts << @context
    end
  end

  module Engine
    require_relative './middleware/builder'
    require_relative './middleware/runner'

    attr_accessor :setup_middlewares
    def setup before_stack = [] 
      @setup_middlewares = before_stack
    end
  end
end
