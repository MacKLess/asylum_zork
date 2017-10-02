#!/usr/bin/env ruby

require 'spec_helper'

describe('Note') do
  let(:note) { Note.new({
    room_id: nil,
    note_text: "This is a super scary note."
  }) }
  
  describe '#room' do
    it "returns the room that a note is located in" do
      room = Room.create({
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
        first_impression: 'you have entered a spooky foyer',
        visited: false
      })
      note.room_id = room.id
      note.save
      expect(note.room).to eq(room)
    end
  end
end
