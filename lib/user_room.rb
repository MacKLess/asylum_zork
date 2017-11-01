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
end
