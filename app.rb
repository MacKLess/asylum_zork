#!/usr/bin/env ruby

require("bundler/setup")
require("csv")
require "pry"
Bundler.require(:default)

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

set :sessions, true

#Moving up here as it only needs to be loaded into the database once. Might want to seed db outside of app.rb
Note.all.each do |note|
  note.destroy
end

CSV.foreach('./lib/seeds/notes_seed.csv', headers: true) do |row|
  attributes = row.to_hash
  Note.create({
    room_name: attributes["room"].downcase,
    note_text: attributes["note_text"]
  })
end

before do
  @user = session[:id] != nil ? User.find(session[:id]) : nil
end

get('/') do
  @index = true
  erb(:index)
end

get('/menu') do
  # Game Reset and Setup
  # Clear user session and game data
  if @user
    @user.items.each do |item|
      item.destroy
    end
    @user.rooms.each do |room|
      room.destroy
    end
    @user.destroy
    session[:id] = nil
  end

  # Remove expired user sessions and game database ( >= 48 hours)
  User.clear_expired(60 * 60 * 48)

  #Create new user session and game data
  @user = User.create({moves: 0, game_text: ""});
  session[:id] = @user.id

  CSV.foreach('./lib/seeds/room_seeds.csv', headers: true) do |row|
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
      visited: attributes["visited"] == "1",
      user_id: @user.id
    })
  end

  CSV.foreach('./lib/seeds/items_seed.csv', headers: true) do |row|
    attributes = row.to_hash
    item_room = Room.where("name = ? AND active = ? AND user_id = ?", attributes["room"].downcase, attributes["room_active"] == "1", @user.id).first
    Item.create({
      name: attributes["name"].downcase,
      in_inventory: false,
      room_id: item_room != nil ? item_room.id : nil,
      user_id: @user.id
    })
  end

  erb(:menu)
end

get('/room/:name') do
  # if no user, redirect to menu
  unless @user
    redirect '/menu'
  end
  # gets a new room, either due to movement or solving a puzzle.
  results = Room.where("name = ? AND active = ? AND user_id = ?", params.fetch(:name), true, @user.id)
  @room = results.length > 0 ? results.first : nil
  @text = @user.game_text.split("\n")
  if @room
    @text.push(@room.title_name)
    @text.push(@room.look)
    @text.push(@room.item ? "There is a #{@room.item.name} here." : nil)
    @text.push(@room.note ? "There is a note here." : nil)
  end
  @moves = @user.moves
  @user.update({
    game_text: @text.join("\n") })
  if @room.title_name == 'Escape Courtyard'
    # If end of game, clears user session and game data
    @user.items.each do |item|
      item.destroy
    end
    @user.rooms.each do |room|
      room.destroy
    end
    @user.destroy
    session[:id] = nil
  end
  erb(:room)
end

post('/room/:name') do
  directions = ['n', 'north', 'e', 'east', 'w', 'west', 's', 'south']
  results = Room.where("name = ? AND active = ? AND user_id =?", params.fetch(:name), true, @user.id)
  if results.length > 0
    @room = results.first
    action = params.fetch(:action).downcase
    # tracks users moves and displays
    @moves = @user.moves
    @moves += 1
    # start of log for this turn
    @text = @user.game_text.split("\n")
    @text.push("")
    @text.push("> " + action)
    @user.update({
      game_text: @text.join("\n"),
      moves: @moves
    })
    if action.start_with?("look")
      # "look" action
      # grabs room.look, and notes if there are items or notes as well.
      @text.push(@room.title_name)
      @text.push(@room.look)
      @text.push(@room.item ? "There is a #{@room.item.name} here." : nil)
      @text.push(@room.note ? "There is a note here." : nil)
      @user.update({
        game_text: @text.join("\n"),
        moves: @moves
      })
      erb(:room)
    elsif action.start_with?("move") || action.start_with?("go") || directions.include?(action)
      # "move" action
      # works if user types verb + direction, or just direction.
      # redirects to new room, or notifies about inaccessible direction.
      new_room = @room.move(action.split(" ")[1] || action)
      if new_room
        redirect '/room/' + new_room.name
      else
        @text.push("You can't go that way.")
        @user.update({
          game_text: @text.join("\n"),
          moves: @moves
        })
        erb(:room)
      end
    elsif action.start_with?("take")
      # "take" action
      # if user inputs name, or one word of name, of item in current room, the item is added to inventory
      result = @room.take(action.split(" ")[1..-1].join(" ") || "")
      if result
        @text.push("Taken.")
      else
        @text.push("You can't take that.")
      end
      @user.update({
        game_text: @text.join("\n"),
        moves: @moves
      })
      erb(:room)
    elsif action.start_with?("use")
      # "use" action
      # room.use returns the 'success' version of a room if correct item is used
      success_room = @room.use(action.split(" ")[1..-1].join(" ") || "")
      if success_room
        redirect '/room/' + success_room.name
      else
        @text.push("You can't use that here.")
        @user.update({
          game_text: @text.join("\n"),
          moves: @moves})
        erb(:room)
      end
    elsif action.start_with?("read")
      # "read" action
      # returns the text of a room's note, or notifies user that there is no note to read
      @text.push(@room.read != nil ? '"' + @room.read + '"' : "There is nothing to read here.")
      @user.update({
        game_text: @text.join("\n"),
        moves: @moves
        })
      erb(:room)
    elsif action.start_with?("inventory")
      # "inventory" action
      # displays all items in inventory
      # does not count as a move
      @moves -= 1
      if Item.inventory(@user.id).any?
        Item.inventory(@user.id).each do |item|
          @text.push("* " + item.name)
        end
      else
        @text.push('Inventory is empty.')
      end
      @user.update({
        game_text: @text.join("\n"),
        moves: @moves
      })
      erb(:room)
    elsif action.start_with?("help")
      # "help" action
      # returns all commands user can enter
      # does not count as a move
      @moves -= 1
      commands = ["Inventory", "Look", "Move [Cardinal Direction or N, E, S, W]", "Take [Item]", "Use [Inventory Item]", "Read [Note]", "Help"]
      @text.push("Commands:")
      commands.each do |command|
        @text.push ("* " + command)
      end
      @user.update({
        game_text: @text.join("\n"),
        moves: @moves
      })
      erb(:room)
    else
      # Anything that is not recognized by the above code, game does not understand.
      @text.push("I don't understand.")
      @user.update({
        game_text: @text.join("\n"),
        moves: @moves
      })
      erb(:room)
    end
  end
end
