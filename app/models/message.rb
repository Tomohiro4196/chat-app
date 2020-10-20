class Message < ApplicationRecord

  validates :content, presence: true

  belongs_to :room
  belongs_to :user
  has_one_attached :image
  #1つのメッセージレコードに対して、1つのimageファイルを紐づける
end
