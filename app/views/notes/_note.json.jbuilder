json.extract! note, :id, :book_id, :title, :content, :created_at, :updated_at
json.url note_url(note, format: :json)
