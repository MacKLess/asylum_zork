#!/usr/bin/env ruby

require("bundler/setup")
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
  test1 = Room.create({
    name: 'foyer',
    description: 'The First Room.',
    x_coordinate: 1,
    y_coordinate: 1,
    active: true,
    solution_item: 'key',
    north_exit: true,
    east_exit: false,
    south_exit: true,
    west_exit: false,
    first_impression: 'you have entered a spooky foyer',
    visited: false
  })
  test2 = Room.create({
    name: 'intake',
    description: 'The Intake Room.',
    x_coordinate: 1,
    y_coordinate: 1,
    active: true,
    solution_item: 'combination',
    north_exit: true,
    east_exit: false,
    south_exit: true,
    west_exit: false,
    first_impression: 'you have entered a dilapitated patient intake room',
    visited: false
  })
  combination = Item.create({:name => 'combination', :room_id => test2.id})
  erb(:index)
end

get('/room/:name')
  @room = Room.where("name = ? AND active = ?", params.fetch(:name), true)
  erb(:room)
end
