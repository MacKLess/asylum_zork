#!/usr/bin/env ruby

require 'spec_helper'

describe 'room actions', { type: :feature } do
  let(:room) { Room.new({
    name: 'start',
    description: 'The First Room.',
    x_coordinate: 1,
    y_coordinate: 1,
    active: true,
    solution_item: 'key',
    north_exit: true,
    east_exit: false,
    south_exit: true,
    west_exit: true,
    first_impression: 'you have entered a spooky foyer',
    visited: false
  }) }
  it "displays the room's first impression the first time you enter a room" do
    room.save
    visit('/room/' + room.name)
    expect(page).to have_content('you have entered a spooky foyer')
  end

  it "displays the current room's description if a user types 'look' after entering" do
    room.save
    room.look
    visit('/room/' + room.name)
    fill_in('action', with: 'look')
    click_button('Act!')
    expect(page).to have_content('The First Room.')
  end
end
