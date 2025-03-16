class HomeController < ApplicationController
  before_action :authenticate_user!, except: [ :index ]

  def index
  end

  def profile
    @user = current_user
  end
end
