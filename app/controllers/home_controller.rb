class HomeController < ActionController::Base
  def index
    render render: 'home/index'
  end
end