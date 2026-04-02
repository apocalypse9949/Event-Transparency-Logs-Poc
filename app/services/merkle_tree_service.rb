class MerkleTreeService
  def self.compute_root(leaf_hashes)
    return nil if leaf_hashes.empty?
    return leaf_hashes.first if leaf_hashes.length == 1

    current_layer = leaf_hashes
    while current_layer.length > 1
      next_layer = []
      current_layer.each_slice(2) do |pair|
        if pair.length == 2
          next_layer << Digest::SHA256.hexdigest(pair[0] + pair[1])
        else
          # RFC 6962: For an odd number of nodes, the last node is promoted
          next_layer << pair[0]
        end
      end
      current_layer = next_layer
    end
    current_layer.first
  end

  def self.inclusion_proof(leaf_hashes, index)
    return [] if leaf_hashes.length <= 1

    proof = []
    current_layer = leaf_hashes
    current_index = index

    while current_layer.length > 1
      next_layer = []
      current_layer.each_slice(2).with_index do |pair, i|
        if pair.length == 2
          if i == current_index / 2
            sibling_index = current_index.even? ? 1 : 0
            proof << { hash: pair[sibling_index], side: current_index.even? ? 'right' : 'left' }
          end
          next_layer << Digest::SHA256.hexdigest(pair[0] + pair[1])
        else
          # Last node with no sibling
          if i == current_index / 2
            # No sibling to add to proof at this level
          end
          next_layer << pair[0]
        end
      end
      current_layer = next_layer
      current_index /= 2
    end
    proof
  end

  def self.verify_proof(leaf_hash, proof, root)
    current_hash = leaf_hash
    proof.each do |step|
      if step[:side] == 'left'
        current_hash = Digest::SHA256.hexdigest(step[:hash] + current_hash)
      else
        current_hash = Digest::SHA256.hexdigest(current_hash + step[:hash])
      end
    end
    current_hash == root
  end
end
