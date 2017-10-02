#!/usr/bin/env ruby

class Room < ActiveRecord::Base

  def move(direction)
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
end
