class RegistryEvent < ApplicationRecord
  serialize :payload, coder: JSON
  before_create :compute_hash

  def self.last_hash
    last&.hash_code || "0" * 64
  end

  private

  def compute_hash
    self.previous_hash = self.class.last_hash
    data = "#{event_type}#{rubygem_id}#{actor_id}#{payload}#{previous_hash}"
    self.hash_code = Digest::SHA256.hexdigest(data)
  end
end
