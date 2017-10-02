#!/usr/bin/env ruby

require 'spec_helper'

describe('Room') do
  let(:room) { Room.new({
    name: 'Start',
    description: 'The First Room.',
    x_coordinate: 1,
    y_coordinate: 1,
    active: true,
    solution_item: 'key',
    success_room: nil,
    north_exit: true,
    east_exit: false,
    south_exit: true,
    west_exit: true,
  }) }

  describe '#look' do
    it "returns the room's description" do
      room.save
      expect(room.look).to eq('The First Room.')
    end
  end

  describe '.find_by_coordinates' do
    it "returns the active room with the coordinates passed in" do
      room.save
      expect(Room.find_by_coordinates(1, 1)).to eq(room)
    end

    it "returns nil if no active room with the coordinates passed in" do
      room.save
      expect(Room.find_by_coordinates(0, 0)).to eq(nil)
    end
  end
end
