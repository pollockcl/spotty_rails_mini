class Admin::BaseController < ApplicationController
  before_action :require_admin

  private

  def require_admin
    render file: '/public/404', status: 404 unless current_user && current_admin
  end
end
