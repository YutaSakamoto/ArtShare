class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @crafts = current_user.crafts
  end
end
