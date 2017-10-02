#!/usr/bin/env ruby

class Note < ActiveRecord::Base
  belongs_to :room
end
