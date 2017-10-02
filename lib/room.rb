#!/usr/bin/env ruby

class Room < ActiveRecord::Base

  def move(direction)
    direction.downcase!
    if (direction == "north") & north_exit
      # return room with coordinates one north
    end
  end

  def look
    self.description
  end

  def take(item)
  end

  def use(item)
  end

  def read(note)
  end

  def self.find_by_coordinates(x, y)
    results = Room.where("x_coordinate = ? AND y_coordinate = ? AND active = ?", x, y, true)
    if results.length > 0
      return results.first
    else
      return nil
    end
  end
end
