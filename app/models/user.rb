class User < ActiveRecord::Base
  # TODO: re-add validatable, confirmable, allow_unconfirmed_access_for: 1.week
  devise :omniauthable, :authenticatable, :database_authenticatable, :recoverable, :registerable, :rememberable

  has_many :articles

  attr_accessible :email, :password, :password_confirmation

  # TODO: default email and password, and also allow setting password from default on 'users/edit'
  def self.create_guest
    create
  end

  def self.find_or_create_for_zotero_oauth(auth)
    self.where(auth).first || User.new.tap do |user|
      user.set_zotero_auth_fields(auth)
      user.save
    end
  end

  def self.find_or_create_for_mendeley_oauth(auth)
    self.where(auth).first || User.new.tap do |user|
      user.set_mendeley_auth_fields(auth)
      user.save
    end
  end

  def set_zotero_auth_fields(auth)
    self.zotero_uid = auth['zotero_uid']
    self.zotero_key = auth['zotero_key']
    self.zotero_username = auth['zotero_username']
  end

  def set_mendeley_auth_fields(auth)
    self.mendeley_uid = auth['mendeley_uid']
    self.mendeley_token = auth['mendeley_token']
    self.mendeley_secret = auth['mendeley_secret']
    self.mendeley_username = auth['mendeley_username']
  end

  def import_from_libraries
    import_articles('zotero', zotero_articles) if zotero?
    import_articles('mendeley', mendeley_articles) if mendeley?
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

  def mendeley?
    !!mendeley_uid
  end

  def mendeley_user
    MendeleyClient::User.new(mendeley_uid, mendeley_token, mendeley_secret)
  end

  def mendeley_items
    mendeley_user.items
  end

  def mendeley_articles
    mendeley_items.select(&:journal_article?)
  end

  private

  def import_articles(source, new_articles)
    new_articles.each do |new_article|
      next if articles.find_by_title_and_source(new_article.title, source)

      identifiers = new_article.identifier_strings.map { |identifier_string|
        Identifier.new(body: identifier_string)
      }

      articles.create({ title: new_article.title, source: source, identifiers: identifiers })
    end
  end
end
