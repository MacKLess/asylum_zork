#!/usr/bin/env ruby

class UserRoom < ActiveRecord::Base
  belongs_to :user
  belongs_to :room
  belongs_to :item
  belongs_to :note

  def look
    if !self.visited
      self.update({visited: true})
      return self.room.first_impression
    else
      return self.room.description
    end
  end

  def read
    return self.room.read
  end

  def take(item_name)
    if self.item
      if Item.recognize(item_name) == self.item
        self.user.items.push(self.item)
        self.update({item_id: nil})
        return true
      end
    end
    return false
  end
end
