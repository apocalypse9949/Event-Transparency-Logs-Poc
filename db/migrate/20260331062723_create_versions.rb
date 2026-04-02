class CreateVersions < ActiveRecord::Migration[8.0]
  def change
    create_table :versions do |t|
      t.string :number
      t.references :rubygem, null: false, foreign_key: true

      t.timestamps
    end
  end
end
