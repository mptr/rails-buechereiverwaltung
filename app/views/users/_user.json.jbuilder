json.extract! user, :id, :family_name, :given_name, :address, :email, :password, :blocked, :remarks, :created_at, :updated_at
json.url user_url(user, format: :json)
