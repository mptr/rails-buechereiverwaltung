json.extract! book_instance, :id, :book_id, :shelfmark, :purchased_at, :lended_by_id, :reserved_by_id, :checkout_at, :due_at, :returned_at, :created_at, :updated_at
json.url book_instance_url(book_instance, format: :json)
