class CreateRubygems < ActiveRecord::Migration[8.0]
  def change
    create_table :rubygems do |t|
      t.string :name

      t.timestamps
    end
  end
end
