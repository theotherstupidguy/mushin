require_relative './middleware/builder'
require_relative './middleware/runner'

module Mushin # Domain Frameworks Generator
  module Errors  
    exceptions = %w[ UnkownDSLConstruct UnkownActivation UnknownOption ]  
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

    class << self
      attr_accessor :contexts, :middlewares
    end
    Mushin::DSL.contexts = []
    def context title, &block
      @context = Mushin::DSL::Context.new title 
      def statment statment=[], &block
	@statment = Mushin::DSL::Statment.new statment 
	def activation name, opts={}, params={}
	  @activation = Mushin::DSL::Activation.new name, opts, params
	  @statment.activations << @activation 
	end
	yield
	@context.statments << @statment
      end
      yield
     Mushin::DSL.contexts << @context
    end
  end

  module Engine
    attr_accessor :setup_middlewares
    def setup before_stack = [] 
      @setup_middlewares = before_stack
    end
  end
end
