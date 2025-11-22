require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Reload code on every request (slower but ideal for development)
  config.enable_reloading = true

  # Do not eager load code on boot
  config.eager_load = false

  # Show full error reports
  config.consider_all_requests_local = true

  # Enable server timing headers
  config.server_timing = true

  # Caching configuration (toggle with `rails dev:cache`)
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end

  # Store uploaded files locally
  config.active_storage.service = :local

  # Mailer configuration for development (letter_opener)
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true
  config.action_mailer.default_url_options = { host: "localhost", port: 3000 }
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false

  # Deprecation handling
  config.active_support.deprecation = :log
  config.active_support.disallowed_deprecation = :raise
  config.active_support.disallowed_deprecation_warnings = []

  # Raise error on page load if there are pending migrations
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true

  # Highlight code that enqueued background jobs in logs
  config.active_job.verbose_enqueue_logs = true

  # Suppress logger output for asset requests
  config.assets.quiet = true

  # Raise error when a before_action's only/except options reference missing actions
  config.action_controller.raise_on_missing_callback_actions = true
end
