class User < ActiveRecord::Base
  devise :omniauthable, :authenticatable

  def self.find_or_create_for_zotero_oauth(auth)
    self.where(auth).first || User.new.tap do |user|
      user.zotero_uid = auth['zotero_uid']
      user.zotero_key = auth['zotero_key']
      user.zotero_username = auth['zotero_username']
      user.save
    end
  end

  def zotero?
    !!zotero_uid
  end

  def zotero_items
    client = ZoteroClient::User.new(zotero_uid, zotero_key)
    client.items
  end
end
