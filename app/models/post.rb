class Post < ApplicationRecord
  belongs_to :user

enum :status, { draft: 0, published: 1 }
     scope :published, -> { where(status: :published) }
     scope :draft,     -> { where(status: :draft) }
 
  validates :title, presence: true
  validates :content, presence: true
end
