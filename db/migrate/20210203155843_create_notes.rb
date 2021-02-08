class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.belongs_to :book, null: false , foreign_key: {on_delete: :cascade}
      t.string :title, null: false
      t.string :content, null: false

      t.timestamps
    end
  end
end
