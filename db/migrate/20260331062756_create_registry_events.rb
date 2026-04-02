class CreateRegistryEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :registry_events do |t|
      t.string :event_type
      t.integer :rubygem_id
      t.integer :actor_id
      t.text :payload
      t.string :previous_hash
      t.string :hash_code

      t.timestamps
    end
  end
end
