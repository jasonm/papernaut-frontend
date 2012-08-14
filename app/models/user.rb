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

  def self.find_or_create_for_mendeley_oauth(auth)
    self.where(auth).first || User.new.tap do |user|
      user.mendeley_uid = auth['mendeley_uid']
      user.mendeley_token = auth['mendeley_token']
      user.mendeley_secret = auth['mendeley_secret']
      user.mendeley_username = auth['mendeley_username']
      user.save
    end
  end

  def zotero?
    !!zotero_uid
  end

  def zotero_user
    ZoteroClient::User.new(zotero_uid, zotero_key)
  end

  def zotero_items
    zotero_user.items
  end

  def zotero_articles
    zotero_user.items.select(&:journal_article?)
  end
end
