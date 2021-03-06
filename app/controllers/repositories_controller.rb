class RepositoriesController < ApplicationController
  def index
    @repositories = Rails.cache.fetch('repositories', expires_in: 1.hour) { OCTOKIT_CLIENT.repositories }
  end

  def show
    @repository = Repository.new(owner: params[:owner], name: params[:name])
  end
end
