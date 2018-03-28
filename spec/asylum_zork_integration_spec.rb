#!/usr/bin/env ruby

require 'spec_helper'

describe 'room actions', { type: :feature } do
  before do
    visit('/menu')
  end
  # let(:room) { Room.new({
  #   name: 'start',
  #   description: 'The First Room.',
  #   x_coordinate: 1,
  #   y_coordinate: 1,
  #   active: true,
  #   solution_item: 'key',
  #   north_exit: true,
  #   east_exit: false,
  #   south_exit: true,
  #   west_exit: true,
  #   first_impression: 'you have entered a spooky foyer',
  #   visited: false
  # }) }
  it "displays the room's first impression the first time you enter a room" do
    visit('/room/yard')
    expect(page).to have_content("You're standing on a once-manicured lawn, the dark mansion looming before you, an imposing structure against the night sky. A loud crash makes you turn and you see that the Southern gate has slammed shut behind you. You rattle the gate's bolt, but the dark steel refuses to budge. You will need to find another way off the premises. To the North is the mansion veranda. To the West lies a greenhouse and, in the distance, to the East you see a chapel just beyond a dog kennel. A guttural howling seems to be coming from somewhere nearby.")
  end

  it "displays the current room's description if a user types 'look' after entering" do
    visit('/room/yard')
    fill_in('action', with: 'look')
    click_button('Act!')
    expect(page).to have_content("You're in an open yard and the dark mansion stands before you, imposing against the night sky. The immovable gate stands to your South. To the North is the mansion veranda. To the West lies a greenhouse and to the East just beyond a dog kennel, you see the windows of an old chapel. A guttural howling seems to be coming from somewhere nearby.")
  end

  it "moves a user to a new room if they type 'move' and a valid direction" do
    visit('/room/yard')
    fill_in('action', with: 'move north')
    click_button('Act!')
    expect(page).to have_content('Veranda')
  end

  it "adds an item to the user's inventory if they type 'take' and a the item's name" do
    visit('/room/intake')
    fill_in('action', with: 'take keycard')
    click_button('Act!')
    expect(page).to have_content('Taken.')
    fill_in('action', with: 'inventory')
    click_button('Act!')
    expect(page).to have_content('* keycard')
  end

  it "sends a user to the success version of a room if they type 'use' and the correct item" do
    visit('/room/intake')
    fill_in('action', with: 'take keycard')
    click_button('Act!')
    fill_in('action', with: 'use keycard')
    click_button('Act!')
    expect(page).to have_content("After inserting the card, you can feel a subtle click from inside the mechanism and the North door opens. To the West stands a door without a doorknob.")
  end

  it "responds to non-keyword text" do
    visit('/room/yard')
    fill_in('action', with: 'hit plant with shovel')
    click_button('Act!')
    expect(page).to have_content("I don't understand.")
  end

  it "prints the text of a room's note (if the room has a note) when user types 'read'" do
    visit('/room/intake')
    fill_in('action', with: 'read')
    click_button('Act!')
    expect(page).to have_content("Dammit, Kelsey, stop forgetting your keycard to the intake door!")
  end
end
