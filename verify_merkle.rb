require_relative 'config/environment'

puts "Total RegistryEvents: #{RegistryEvent.count}"

# 1. Verify Event Chaining
events = RegistryEvent.order(:id).to_a
events.each_with_index do |event, i|
  if i > 0
    if event.previous_hash == events[i-1].hash_code
      puts "Event #{event.id}: Chaining is VALID"
    else
      puts "Event #{event.id}: Chaining FAILED (Prev: #{event.previous_hash}, Actual: #{events[i-1].hash_code})"
    end
  else
    puts "Event #{event.id}: Root event (Prev: #{event.previous_hash})"
  end
end

# 2. Verify Merkle Root
leaf_hashes = events.map(&:hash_code)
root = MerkleTreeService.compute_root(leaf_hashes)
puts "Computed Merkle Root: #{root}"

# 3. Verify Inclusion Proof for the 3rd event
if events.size >= 3
  test_event = events[2]
  index = 2
  proof = MerkleTreeService.inclusion_proof(leaf_hashes, index)
  puts "Generated proof for Event #{test_event.id} (index #{index})"
  
  is_valid = MerkleTreeService.verify_proof(test_event.hash_code, proof, root)
  puts "Inclusion Proof status: #{is_valid ? 'SUCCESS' : 'FAILURE'}"
end
