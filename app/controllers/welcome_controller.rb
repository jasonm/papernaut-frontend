class WelcomeController < ApplicationController
  def index
    if signed_in?
      redirect_to :discussions
      return
    end
  end
end
