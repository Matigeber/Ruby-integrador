class Book < ApplicationRecord
  belongs_to :user
  validates :name, uniqueness: {scope: :user,
                                message: "there is already a book with this name"},
            presence: true, length: {maximum: 60}
  has_many :notes, inverse_of: :book

  def find_note(id)
    self.notes.find(id)
  end
  
  def export_notes
    notes.each { |note| note.export }
  end

end
