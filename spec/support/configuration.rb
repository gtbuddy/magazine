def reset_configuration
  Magazine.configure do |config|
    config.current_blogger_method = :current_user
  end
end