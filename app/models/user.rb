class User < ApplicationRecord
  has_many :ownerships
  has_many :rubygems, through: :ownerships
end
