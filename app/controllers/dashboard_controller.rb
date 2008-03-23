class DashboardController < ApplicationController
  before_filter :domain_required
  before_filter :login_required

  def index
    @logs = current_account.logs.find(:all, :order => 'published_at DESC', :limit => 5)
    @recent_matches = current_account.matches.find_recent(nil, :limit => 10, :include => { :teams => :memberships })
    @comments = Comment.find(:all, :conditions => { :user_id => current_account.user_ids }, :limit => 5, :order => 'created_at DESC')

    unless cached?
      @rankings = current_account.ranked_users
      @newbies = current_account.newbie_users
      @matches_per_day = current_account.matches.count(:group => :played_on, :limit => 10, :order => 'matches.played_on DESC')

      # Sidebar
      @leader = @rankings.size > 0 ? @rankings[0] : @newbies[0]
      @match_count = current_account.matches.count
      @goals_scored = current_account.users.sum(:goals_for) / 2
      @all_time_high = Membership.all_time_high(current_account)
      @all_time_low = Membership.all_time_low(current_account)
    end
  end

  protected
  def cached?
    read_fragment(cache_key) && read_fragment(cache_key('sidebar'))
  end
end