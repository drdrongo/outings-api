# config/initializers/cors.rb
# frozen_string_literal: true

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

to_regexp = ->(string) { Regexp.new(string) }
hosts = [
  *ENV.fetch('ALLOWED_ORIGINS').split(','),
  *ENV.fetch('ALLOWED_ORIGIN_REGEXPS').split(';').map(&to_regexp)
]

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(*hosts)

    resource '*',
             methods: %i[get post put patch delete options head],
             headers: :any
  end
end



# Rails.application.config.middleware.insert_before 0, Rack::Cors do



  # allow do
  #   origins 'http://localhost:3000'
  #   resource '*',
  #     headers: :any,
  #     methods: [:get, :post, :put, :delete]
  # end

#   allow do
#     origins 'http://localhost:3000'
#     resource '*',
#       headers: :any,
#       methods: [:get, :post, :put, :delete]
#   end
# end
