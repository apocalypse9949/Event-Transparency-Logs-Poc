class Api::V1::TransparencyLogsController < ApplicationController
  def head
    leaf_hashes = RegistryEvent.order(:id).pluck(:hash_code)
    root = MerkleTreeService.compute_root(leaf_hashes)
    
    render json: {
      root_hash: root,
      tree_size: leaf_hashes.length,
      timestamp: Time.current
    }
  end

  def proof
    event = RegistryEvent.find(params[:event_id])
    leaf_hashes = RegistryEvent.order(:id).pluck(:hash_code)
    index = leaf_hashes.index(event.hash_code)
    
    proof = MerkleTreeService.inclusion_proof(leaf_hashes, index)
    
    render json: {
      event_id: event.id,
      leaf_hash: event.hash_code,
      proof: proof,
      root_hash: MerkleTreeService.compute_root(leaf_hashes)
    }
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Event not found" }, status: :not_found
  end

  def verify
    leaf_hash = params[:leaf_hash]
    proof = params[:proof].map { |p| p.to_h.symbolize_keys }
    root = params[:root_hash]

    is_valid = MerkleTreeService.verify_proof(leaf_hash, proof, root)

    render json: { valid: is_valid }
  end
end
