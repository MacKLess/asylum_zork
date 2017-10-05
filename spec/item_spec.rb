#!/usr/bin/env ruby

require 'spec_helper'

describe('Item') do
  let(:item) { Item.new({
    name: "key",
    room_id: nil,
    in_inventory: false,
  }) }

  describe('.inventory') do
    it("returns all items in inventory") do
      item.in_inventory = true
      item.save
      expect(Item.inventory).to eq([item])
    end
  end

  describe('.recognize') do
    it "finds an item by one word in its name" do
      item = Item.create({
        name: 'harpoon gun',
        room_id: nil,
        in_inventory: false
      })
      expect(Item.recognize('harpoon')).to(eq(item))
      expect(Item.recognize('gun')).to(eq(item))
    end

    it "returns nil if an item is not recognized" do
      item.name = "pig's head"
      item.save
      expect(Item.recognize('pig head')).to eq(nil)
    end
  end
end
