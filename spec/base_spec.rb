require_relative './spec_helper'

describe Mushin::Errors do
end

describe Mushin::Env do
  before do 
    #Domain.send :include, Mushin::Env
  end
  it 'registers a code block to the Env module' do 
    skip
    module Domain
      module Env
	extend Mushin::Env
	register do 
	end
      end
    end
  end
end

describe Mushin::Middleware, 'provides an extendable functionality to Domain Specific Middlewares' do 
  before do 
    module SomeDomainMiddleware 
      include Mushin::Middleware
      module Opts
      end
    end
    #SomeDomainMiddleware::Opts[:option_key] = "option_value"
  end
  it 'enables setting and getting options' do 
    #skip
    #SomeDomainMiddleware::Opts[:option_key].must_equal "option_value" 
  end
end


describe Mushin::DSL, 'provides an extendable functionality of DSLs' do 
  before do 
    end
  it 'dsl in a dsl book' do 
  #skip
    module Gamebook
      extend Mushin::DSL
      context 'c' do 
	statment 's' do
	  activation 'a'
	end
      end
    end
    module Pentest 
      extend Mushin::DSL
      context 'c' do 
	statment 's' do
	  activation 'a'
	end
      end
    end
    Mushin::DSL.contexts.count.must_equal 2 
    Mushin::DSL.contexts.must_be_kind_of Array
    Mushin::DSL.contexts[0].must_be_kind_of Mushin::DSL::Context 
    Mushin::DSL.contexts[0].title.must_equal 'c' 
    Mushin::DSL.contexts[0].statments[0].must_be_kind_of Mushin::DSL::Statment
  end
end
