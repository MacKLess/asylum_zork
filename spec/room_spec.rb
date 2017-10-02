#!/usr/bin/env ruby

require 'spec_helper'

describe('Room') do
  let(:room) { Room.create({
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
      expect(room.look).to eq('The First Room.')
    end
  end
end
