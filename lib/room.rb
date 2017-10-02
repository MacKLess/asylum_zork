#!/usr/bin/env ruby

class Room < ActiveRecord::Base
  has_one :item

  def move(direction)
    direction.downcase!
    if (direction == "north") & north_exit
      return Room.find_by_coordinates(self.x_coordinate, self.y_coordinate + 1)
    elsif (direction == "east") & east_exit
      return Room.find_by_coordinates(self.x_coordinate + 1, self.y_coordinate)
    elsif (direction == "south") & south_exit
      return Room.find_by_coordinates(self.x_coordinate, self.y_coordinate - 1)
    elsif (direction == "west") & west_exit
      return Room.find_by_coordinates(self.x_coordinate - 1, self.y_coordinate)
    else
      return nil
    end
  end

  def look
    if !self.visited
      self.visited = true
      return self.first_impression
    else
      return self.description
    end
  end

  def take(item)
    if item.downcase == self.item.name.downcase
      self.item.update({room_id: nil, in_inventory: true})
    else
      return false
    end
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
