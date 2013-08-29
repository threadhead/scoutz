json.array!(@users) do |user|
  json.extract! user, :full_name, :email
  json.url user_url(user, format: :json)
end
