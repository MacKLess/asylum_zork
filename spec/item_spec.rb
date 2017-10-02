#!/usr/bin/env ruby

require 'spec_helper'

describe('Item') do
  let(:item) { Item.new({
    name: "key",
    room_id: nil,
    in_inventory: false,
    used: false
  }) }

  describe('.inventory') do
    it("returns all items in inventory") do
      item.in_inventory = true
      item.save
      expect(Item.inventory).to eq([item])
    end
  end

  describe('.in_inventory') do
    it("returns whether a specific item is in the inventory") do
      item.in_inventory = true
      item.save
      expect(Item.in_inventory?(item.name)).to eq(true)
    end
  end



end
