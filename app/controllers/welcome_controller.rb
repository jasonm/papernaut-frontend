class WelcomeController < ApplicationController
  def index
    if signed_in? && current_user.zotero?
      @discussed_items = DiscussedItem.for_zotero_user(current_user.zotero_user)
    end
  end
end
