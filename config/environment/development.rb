# Specify environment specific .env files
configure :development do
  activate :dotenv, env: '.env.development'
end
