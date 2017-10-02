#!/usr/bin/env ruby

class Item < ActiveRecord::Base
  belongs_to :room
  scope(:inventory, -> do
    where({:in_inventory => true})
  end)


    
end
