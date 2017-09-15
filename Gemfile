source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'

gem 'active_model_serializers', '~> 0.10.0.rc3'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', '1.3.13'
# Use Puma as the app server
gem 'puma', '~> 3.7'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '9.1.0', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_girl_rails', '4.8.0'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '2.0.2'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rspec-rails', '~> 3.5'
  gem 'json_spec', '1.1.5'
  gem 'timecop', '0.9.1'
end

