ENV['RACK_ENV'] = 'test'

require('sinatra/activerecord')
require('capybara/rspec')
require('pry')

Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each { |file| require file }

RSpec.configure do |config|

  config.before(:each) do
    Recipe.all().each() do |recipe|
      recipe.destroy()
    end
    Ingredient.all().each() do |ingredient|
      ingredient.destroy()
    end
  end


  config.after(:each) do
    Recipe.all().each() do |recipe|
      recipe.destroy()
    end
    Ingredient.all().each() do |ingredient|
      ingredient.destroy()
    end
  end

end
