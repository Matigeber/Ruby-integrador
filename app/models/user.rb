class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, inverse_of: :user

  after_create :create_global_book

  def create_global_book
    self.books.create(name: 'Global')
  end

  def search_book(id)
    self.books.find(id)
  end

  def export_all_books
    self.books.each {|book| book.export_notes}
  end
end
