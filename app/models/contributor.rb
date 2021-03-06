class Contributor
  attr_reader :user, :repo

  def initialize(user, repo)
    @user = user
    @repo = repo
  end

  def last_contributed_at
    Date.parse(commits.first.commit.author.date)
  end

  def contributions_for_week
    commits.each_with_object(Array.new(7, 0)) do |commit, result|
      date = Date.parse(commit.commit.author.date)
      if this_week?(date)
        result[date.cwday - 1] += 1
      end
    end
  end

  private

  def this_week?(date)
    date >= Date.today.beginning_of_week && date <= Date.today.end_of_week
  end

  def commits
    Rails.cache.fetch("contributor:commits:#{user}:#{repo}", expires_in: 1.hour) do
      OCTOKIT_CLIENT.commits(repo, 'master', author: user)
    end
  end
end
