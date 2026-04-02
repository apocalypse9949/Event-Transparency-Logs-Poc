class Rubygem < ApplicationRecord
  has_many :versions
  has_many :ownerships
  has_many :registry_events
end
