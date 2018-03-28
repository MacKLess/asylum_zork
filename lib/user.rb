#!/usr/bin/env ruby

class User < ActiveRecord::Base
  has_many :rooms
  has_many :items

  def self.clear_expired(timeframe)
    User.where("updated_at <= ?", Time.now - (timeframe)).each do |user|
      user.rooms.each do |room|
        room.destroy
      end
      user.items.each do |item|
        item.destroy
      end
      user.destroy
    end
  end
end
