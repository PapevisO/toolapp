# Be sure to restart your server when you modify this file.

GithubManager::BaseService.configure do |config|
  config.owner_repo = 'PapevisO/toolapp-specs'
  config.branch = ENV['RAILS_ENV'] == 'test' ? 'test' : 'master'
end
