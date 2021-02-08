class Note < ApplicationRecord
  belongs_to :book
  validates :title, uniqueness: {scope: :book,
                                message: "A note with this name already exists in the book"},
            presence: true, length: {maximum: 40}


  def export
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true)
    render = markdown.render(self.content)
    self.content = render
    self.save
  end
end
