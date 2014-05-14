require_relative './middleware/builder'
require_relative './middleware/runner'

module Mushin 
  module DSL
    module Notebook
      def self.extended(mod)
	puts "#{self} extended in #{mod}"
	self.send(:include, mod)
      end

      def self.find activity_construct, activity_rule
	@@middlewares = []
	@@constructs.each do |construct|
	  if activity_construct == construct.title
	    construct.rules.each do |rule|
	      if activity_rule == rule.title
		rule.all_dynamix.each do |middleware|
		  @@middlewares << middleware 
		end
	      end
	    end
	  end
	end
	@@middlewares
      end
    end

    class Activities
      def self.on domain_context, &block 

	@@domain_context = domain_context 
	@@activities = []

	def add activity=[] 
	  @@activities += [activity] 
	end

	yield Activities.new

	@@activities.each do |activity| 
	  self.construction @@domain_context, activity
	end 
      end

      def self.domain_context
	@@domain_context
      end

      def self.all
	@@activities
      end

      def self.count
	@@activities.count 
      end
    end
  end

  class Env
    class << self
      attr_accessor :id
    end

    def Env.register &block
      #instance_eval &block
      class_eval &block
    end

    def Env.activate id, &block
      @id = id
      yield
    end
  end

  module Engine
    def Engine.setup before_stack = [] 
      @@setup_middlewares = before_stack
    end

    def Engine.run domain_context, activity
      p 'Mushin::Engine is running'
      @@domain_context = domain_context
      @@activity = activity
      #TODO write metaprog code in Mushin::DSL::Gamebooks to figure out the modules that included it via the included(self) and then trigger the find function on it to get its own domain
      @@middlewares = Mushin::DSL::Notebook.find @@domain_context, @@activity 
      #p @@middlewares
      @@stack = Middleware::Builder.new do
	#use GameOn::Persistence::DS
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
