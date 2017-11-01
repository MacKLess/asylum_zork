#!/usr/bin/env ruby

class InventoryItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :item
end
