#!/usr/bin/env ruby

class User < ActiveRecord::Base
  has_many :rooms
  has_many :items
end
