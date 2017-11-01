ENV['RACK_ENV'] = 'test'

require("bundler/setup")
Bundler.require(:default, :test)
set(:root, Dir.pwd())

require('capybara/rspec')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)
require('./app')

Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each { |file| require file }

RSpec.configure do |config|
  config.after(:each) do
    Room.all.each do |room|
      room.destroy
    end

    Item.all.each do |item|
      item.destroy
    end

    Note.all.each do |note|
      note.destroy
    end

    User.all.each do |user|
      user.destroy
    end

    InventoryItem.all.each do |inv_item|
      inv_item.destroy
    end
  end
end
