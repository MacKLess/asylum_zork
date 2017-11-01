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
end
