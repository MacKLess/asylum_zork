#!/usr/bin/env ruby

require("bundler/setup")
require("csv")
require "pry"
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

text = []
moves = 0

get('/') do
  # Database Reset and Setup
  text = []
  moves = 0
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

  CSV.foreach('./lib/seeds/notes_seed.csv', headers: true) do |row|
    attributes = row.to_hash
    Note.create({
      room_name: attributes["room"].downcase,
      note_text: attributes["note_text"]
    })
  end

  erb(:index)
end

get('/room/:name') do
  results = Room.where("name = ? AND active = ?", params.fetch(:name), true)
  @room = results.length > 0 ? results.first : nil
  if @room
    text.push(@room.title_name)
    text.push(@room.look)
    if @room.item
      text.push("There is a #{@room.item.name} here.")
    end
    if @room.note
      text.push("There is a note here.")
    end
  end
  @moves = moves
  @text = text
  erb(:room)
end

post('/room/:name') do
  results = Room.where("name = ? AND active = ?", params.fetch(:name), true)
  if results.length > 0
    @room = results.first
    action = params.fetch(:action).downcase
    moves += 1
    @moves = moves
    text.push("")
    text.push("> " + action)
    if action.start_with?("look")
      text.push(@room.look)
      if @room.item
        text.push("There is a #{@room.item.name} here.")
      end
      if @room.note
        text.push("There is a note here.")
      end
      @text = text
      erb(:room)
    elsif action.start_with?("move") || action.start_with?("go")
      new_room = @room.move(action.split(" ")[1] || "")
      if new_room
        redirect '/room/' + new_room.name
      else
        text.push("You can't go that way.")
        @text = text
        erb(:room)
      end
    elsif action.start_with?("take")
      result = @room.take(action.split(" ")[1..-1].join(" ") || "")
      if result
        text.push("Taken.")
      else
        text.push("You can't take that.")
      end
      @text = text
      erb(:room)
    elsif action.start_with?("use")
      success_room = @room.use(action.split(" ")[1..-1].join(" ") || "")
      if success_room
        redirect '/room/' + success_room.name
      else
        text.push("You can't use that here.")
        @text = text
        erb(:room)
      end
    elsif action.start_with?("read")
      text.push(@room.read != nil ? '"' + @room.read + '"' : "There is nothing to read here.")
      @text = text
      erb(:room)
    elsif action.start_with?("inventory")
      moves -= 1
      @moves = moves
      if Item.inventory.any?
        Item.inventory.each do |item|
          text.push(item.name)
        end
      else
        text.push('Inventory is empty.')
      end
      @text = text
      erb(:room)
    else
      text.push("I don't understand.")
      @text = text
      erb(:room)
    end
  end
end
