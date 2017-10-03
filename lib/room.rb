#!/usr/bin/env ruby

class Room < ActiveRecord::Base
  has_one :item
  has_one :note

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
      self.update({visited: true})
      return self.first_impression
    else
      return self.description
    end
  end

  def take(item)
    if self.item
      if item.downcase == self.item.name.downcase
        return self.item.update({room_id: nil, in_inventory: true})
      end
    end
    return false
  end

  def use(item)
    if self.solution_item
      if (item.downcase == self.solution_item.downcase) & Item.in_inventory?(item)
        success_room = Room.where("name = ? AND active = ?", self.name, false).first
        self.update({active: false})
        success_room.update({active: true})
        item = Item.find_by(name: item.downcase)
        item.update({in_inventory: false})
        return success_room
      end
    end 
  end

  def read
    if self.note
      return self.note.note_text
    else
      return nil
    end
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
