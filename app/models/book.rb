class Book < ApplicationRecord
  belongs_to :user
  validates :name, uniqueness: {case_sensitive: false,
                                scope: :user,
                                message: "there is already a book with this name"},
            presence: true, length: {maximum: 60}
  has_many :notes, inverse_of: :book, :dependent => :delete_all

  def find_note(id)
    self.notes.find(id)
  end
  
  def export_notes
    notes.each { |note| note.transform_to_html }
  end

  def is_global?
    self.name.downcase == 'global'
  end

end
