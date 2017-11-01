#!/usr/bin/env ruby

class User < ActiveRecord::Base
  has_many :inventory_items
  has_many :items, through: :inventory_items
end
