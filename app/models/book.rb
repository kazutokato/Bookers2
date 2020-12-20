class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  def self.looks(searchs, words) # 検索機能
    if searchs == "perfect_match"
      @book = Book.where("title LIKE ?", "#{words}") # 完全一致
    elsif searchs == "forward_match"
      @book = Book.where("title LIKE ?", "#{words}%") #前方一致
    elsif searchs == "backward_match"
      @book = Book.where("title LIKE ?", "%#{words}") #前方一致
    else
      @book = Book.where("title LIKE ?", "%#{words}%") # 部分一致
    end
  end


  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

end
