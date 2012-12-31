class Import < ActiveRecord::Base
  belongs_to :user

  validates :state, inclusion: %w(running)
  validates :user_id, presence: true
end
