#!/usr/bin/env ruby

class Item < ActiveRecord::Base
  belongs_to :room
end
