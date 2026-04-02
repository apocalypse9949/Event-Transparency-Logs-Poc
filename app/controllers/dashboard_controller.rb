class DashboardController < ApplicationController
  def index
    @rubygems = Rubygem.includes(:versions, :registry_events).all
    @recent_events = RegistryEvent.order(created_at: :desc).limit(10)
    
    leaf_hashes = RegistryEvent.order(:id).pluck(:hash_code)
    @merkle_root = MerkleTreeService.compute_root(leaf_hashes)
    @tree_size = leaf_hashes.length
  end
end
