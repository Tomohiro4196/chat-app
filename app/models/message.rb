class Message < ApplicationRecord

  validates :content, presence: true, unless: :was_attached?
  #privateメソッド参照

  belongs_to :room
  belongs_to :user
  has_one_attached :image
  #1つのメッセージレコードに対して、1つのimageファイルを紐づける

  private

  def was_attached?
    self.image.attached?
    #messageのparamsにimageが添付されているかを確認するメソッド
  end
end
