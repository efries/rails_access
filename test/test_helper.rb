# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }


### Load fixtures via the engine for all our tests

if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
  ActiveSupport::TestCase.fixtures :all
end

if ActionController::TestCase.method_defined?(:fixture_path=)
  ActionController::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
  ActionController::TestCase.fixtures :all
end

if ActionDispatch::IntegrationTest.method_defined?(:fixture_path=)
  ActionDispatch::IntegrationTest.fixture_path = File.expand_path("../fixture", __FILE__)
  ActionDispatch::IntegrationTest.fixtures :all
end


# Patch TestCase to provide routes: 
# See https://github.com/rails/rails/issues/6573
class ActionController::TestCase
  def method_missing(selector, *args)
    if @controller.respond_to?(:_routes) &&
        ( @controller._routes.named_routes.helpers.include?(selector) ||
          @controller._routes.mounted_helpers.method_defined?(selector) )
      @controller.__send__(selector, *args)
    else
      super
    end
  end    
end

