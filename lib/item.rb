#!/usr/bin/env ruby

class Item < ActiveRecord::Base
  belongs_to :room
  belongs_to :user
  scope(:inventory, -> do
    where({:in_inventory => true})
  end)

  def self.recognize(term)
    Item.all.each do |item|
      if (item.name.downcase == term.downcase) | item.name.downcase.split(" ").include?(term.downcase)
        return item
      end
    end
    nil
  end
end
