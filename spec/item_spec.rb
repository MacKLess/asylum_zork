#!/usr/bin/env ruby

require 'spec_helper'

describe('Item') do
  let(:user) { User.create({
    game_text: "",
    moves: 0
    })}
  let(:item) { Item.new({
    name: "key",
    room_id: nil,
    user_id: user.id,
    in_inventory: false,
  }) }

  describe('.inventory') do
    it "returns all items in a user's inventory" do
      item.in_inventory = true
      item.save
      expect(Item.inventory(user.id)).to eq([item])
    end

    it "does not return items that are not assigned to the user" do
      item.in_inventory = true
      item.user_id = user.id + 1
      expect(Item.inventory(user.id)).to eq([])
    end
  end

  describe('.recognize') do
    it "finds an item by one word in its name" do
      item = Item.create({
        name: 'harpoon gun',
        user_id: user.id,
        room_id: nil,
        in_inventory: false
      })
      expect(Item.recognize('harpoon', user.id)).to(eq(item))
      expect(Item.recognize('gun', user.id)).to(eq(item))
    end

    it "returns nil if an item is not recognized" do
      item.name = "pig's head"
      item.save
      expect(Item.recognize('pig head', user.id)).to eq(nil)
    end

    it "only returns items assigned to user" do
      item2 = Item.create({
        name: "key",
        room_id: nil,
        user_id: user.id + 1,
        in_inventory: false,
        })
      expect(Item.recognize("key", user.id)).to eq(nil)
    end
  end

  describe '#user' do
    it "returns the user an item is assigned to" do
      item.save
      expect(item.user).to eq(user)
    end
  end

end
