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

end
