#!/usr/bin/env ruby

require("bundler/setup")
require("csv")
require "pry"
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

get('/') do
  # Database Reset and Setup
  Room.all.each do |room|
    room.destroy
  end

  Item.all.each do |item|
    item.destroy
  end

  Note.all.each do |note|
    note.destroy
  end

  CSV.foreach('./lib/seeds/all_room_seeds_draft1.csv', headers: true) do |row|
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

get('/room/:name') do
  results = Room.where("name = ? AND active = ?", params.fetch(:name), true)
  @room = results.length > 0 ? results.first : nil
  @text = @room.look
  erb(:room)
end

post('/room/:name') do
  results = Room.where("name = ? AND active = ?", params.fetch(:name), true)
  if results.length > 0
    @room = results.first
    action = params.fetch(:action).downcase
    if action.start_with?("look")
      @text = @room.look
      erb(:room)
    elsif action.start_with?("move") || action.start_with?("go")
      new_room = @room.move(action.split(" ")[1])
      if new_room
        redirect '/room/' + new_room.name
      else
        @text = "You can't go that way."
        erb(:room)
      end
    elsif action.start_with?("take")
      result = @room.take(action.split(" ")[1])
      if result
        @text = "Taken."
      else
        @text = "You can't take that."
      end
      erb(:room)
    elsif action.start_with?("use")
      success_room = @room.use(action.split(" ")[1])
      if success_room
        redirect '/room/' + success_room.name
      else
        @text = "You can't use that here."
        erb(:room)
      end
    elsif action.start_with?("inventory")
      @text = []
      inventory = Item.inventory
      @text = inventory.map do |item|
        item.name
      end
      erb(:room)
    else
      @text = "I don't understand."
      erb(:room)
    end


  end
end
