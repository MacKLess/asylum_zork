#!/usr/bin/env ruby

class Item < ActiveRecord::Base
  belongs_to :room
  scope(:inventory, -> do
    where({:in_inventory => true})
  end)

  def self.in_inventory?(item)
    result = Item.where("name = ? AND in_inventory = ?", item.downcase, true)
    return result.length > 0
  end
end
