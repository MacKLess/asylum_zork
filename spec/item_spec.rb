#!/usr/bin/env ruby

require 'spec_helper'

describe('Item') do
  let(:item) { Item.new({
    name: "key",
    room_id: nil,
    in_inventory: false,
    used: false
  }) }

end
