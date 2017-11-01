#!/usr/bin/env ruby

require 'spec_helper'

describe('User') do
  let(:user) {
    User.create({
      moves: 0,
      game_text: ""
      })
  }
  describe('.items') do
    it "returns all items in inventory" do
      item = Item.create({
        name: "key",
        room_id: nil,
        })
      inv_item = InventoryItem.create({
        user_id: user.id,
        item_id: item.id
        })
      expect(user.items).to eq([item])
    end
  end

  describe('.user_rooms') do
    it "returns all room instances in a user's game" do
      user_room = UserRoom.create({
        user_id: user.id,
        room_id: nil,
        active: true,
        visited: false,
        })
      expect(user.user_rooms).to eq([user_room])
    end
  end

  describe('.rooms') do
    it "returns all room templates assigned to a user" do
      room = Room.create({
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
        first_impression: 'you have entered a spooky foyer',
        })
      user_room = UserRoom.create({
        user_id: user.id,
        room_id: room.id,
        active: room.active,
        visited: false,
        })
      expect(user.rooms).to eq([room])
    end
  end
end
