ENV['RACK_ENV'] = 'test'

require('sinatra/activerecord')
require('capybara/rspec')

Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each { |file| require file }
