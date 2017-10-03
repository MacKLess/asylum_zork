#!/usr/bin/env ruby

require("bundler/setup")
require("csv")
require "pry"
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

get('/') do
  #set up game files, DB, etc.
  # TEST CODE FOR CHECKING VIEWS
  Room.all.each do |room|
    room.destroy
  end

  Item.all.each do |item|
    item.destroy
  end

  Note.all.each do |note|
    note.destroy
  end
  
  CSV.foreach('./lib/seeds/rooms_seed.csv', headers: true) do |row|
    attributes = row.to_hash
    Room.create({
      name: attributes["name"].downcase,
      first_impression: attributes["first_impression"],
      description: attributes["description"],
      x_coordinate: attributes["x_coordinate"].to_i,
      y_coordinate: attributes["y_coordinate"].to_i,
      active: attributes["active"] == "1",
      solution_item: attributes["solution_item"] != nil ? attributes["solution_item"].downcase : nil,
      north_exit: attributes["north_exit"] == "1",
      east_exit: attributes["east_exit"] == "1",
      south_exit: attributes["south_exit"] == "1",
      west_exit: attributes["west_exit"] == "1",
      visited: attributes["visited"] == "1"
    })
  end

  CSV.foreach('./lib/seeds/items_seed.csv', headers: true) do |row|
    attributes = row.to_hash
    item_room = Room.where("name = ? and active = ?", attributes["room"].downcase, attributes["room_active"] == "1").first
    Item.create({
      name: attributes["name"].downcase,
      in_inventory: false,
      room_id: item_room != nil ? item_room.id : nil
    })
  end
  erb(:index)
end
#
# get('/room/:name')
#   @room = Room.where("name = ? AND active = ?", params.fetch(:name), true)
#   erb(:room)
# end
