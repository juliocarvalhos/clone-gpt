json.extract! message, :id, :text, :conversation_id, :user_id, :created_at, :updated_at
json.url message_url(message, format: :json)
