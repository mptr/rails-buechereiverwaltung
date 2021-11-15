json.extract! author, :id, :family_name, :given_name, :affiliation, :created_at, :updated_at
json.url author_url(author, format: :json)
