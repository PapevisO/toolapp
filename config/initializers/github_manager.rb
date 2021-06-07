# Be sure to restart your server when you modify this file.

Rails.logger.info "GithubManager::BaseService.config\t#{GithubManager::BaseService.config}"

GithubManager::BaseService.configure do |config|
  config.owner_repo = 'PapevisO/toolapp-specs'
  config.branch = ENV['RAILS_ENV'] == 'test' ? 'test' : 'master'
end
