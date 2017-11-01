#!/usr/bin/env ruby

class UserRoom < ActiveRecord::Base
  belongs_to :user
  belongs_to :room
  belongs_to :item
  belongs_to :note
end
