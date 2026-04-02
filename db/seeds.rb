# Create some users
alice = User.find_or_create_by!(email: "alice@example.com", name: "Alice")
bob = User.find_or_create_by!(email: "bob@example.com", name: "Bob")

# Create some gems and versions
rails = Rubygem.find_or_create_by!(name: "rails")
devise = Rubygem.find_or_create_by!(name: "devise")

# Create initial publication events
RegistryEvent.create!(
  event_type: "publication",
  rubygem_id: rails.id,
  actor_id: alice.id,
  payload: { version: "1.0.0" }.to_json
)

RegistryEvent.create!(
  event_type: "publication",
  rubygem_id: devise.id,
  actor_id: bob.id,
  payload: { version: "1.0.0" }.to_json
)

# New version
Version.create!(number: "1.1.0", rubygem: rails)
RegistryEvent.create!(
  event_type: "version_pushed",
  rubygem_id: rails.id,
  actor_id: alice.id,
  payload: { version: "1.1.0" }.to_json
)

# Ownership change
Ownership.create!(user: bob, rubygem: rails)
RegistryEvent.create!(
  event_type: "ownership_added",
  rubygem_id: rails.id,
  actor_id: alice.id,
  payload: { added_user: "bob@example.com" }.to_json
)
