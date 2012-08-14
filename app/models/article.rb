class Article < ActiveRecord::Base
  belongs_to :user
  has_many :identifiers

  attr_accessible :title, :source, :identifiers

  def identifier_strings
    identifiers.map(&:body)
  end
end
