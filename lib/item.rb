#!/usr/bin/env ruby

class Item < ActiveRecord::Base
  belongs_to :room
  belongs_to :user

  def self.inventory(user_id)
    Item.where("user_id = ? AND in_inventory = ?", user_id, true)
  end

  def self.recognize(term, user_id)
    Item.where("user_id = ?", user_id).each do |item|
      if (item.name.downcase == term.downcase) | item.name.downcase.split(" ").include?(term.downcase)
        return item
      end
    end
    nil
  end
end
