#!/usr/bin/env ruby

class User < ActiveRecord::Base
  has_many :inventory_items
  has_many :user_rooms
  has_many :items, through: :inventory_items
  has_many :rooms, through: :user_rooms
end
