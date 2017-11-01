#!/usr/bin/env ruby

require 'spec_helper'

describe('UserRoom') do
  let(:room) { Room.create({
    name: 'Start',
    description: 'The First Room.',
    x_coordinate: 1,
    y_coordinate: 1,
    active: true,
    solution_item: 'key',
    north_exit: true,
    east_exit: false,
    south_exit: true,
    west_exit: true,
    first_impression: 'you have entered a spooky foyer'
    }) }
  let(:user_room) {UserRoom.create({
    user_id: nil,
    room_id: room.id,
    active: room.active,
    visited: false,
    }) }
  describe('.room') do
    it "returns the room template associated with the user_room" do
      expect(user_room.room).to eq(room)
    end
  end

  describe('.look') do
    it "returns the first impression if a user_room has not been visited" do
      expect(user_room.look).to eq("you have entered a spooky foyer")
    end

    it "returns the regular description if a user_room has been visited" do
      user_room.look
      expect(user_room.look).to eq('The First Room.')
    end
  end

  describe('.read') do
    it "returns the text of the room's note" do
      note = Note.create({
        room_name: room.name,
        note_text: "This is a Note!"
        })
      expect(user_room.read).to eq("This is a Note!")
    end
  end

  describe('.take') do
    it "moves the room's item from the room to inventory" do
      user = User.create({
        moves: 0,
        game_text: ""
        })
      item = Item.create({
        name: "keycard",
        room_id: room.id,
        })
      user_room.item_id = item.id
      user_room.user_id = user.id
      user_room.take(item.name)
      expect(user.items).to eq([item])
      expect(user_room.item).to eq(nil)
    end
  end
end
