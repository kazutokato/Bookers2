class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  include JpPrefecture
  jp_prefecture :prefecture_code

  def prefecture_name
    jp_prefecture::prefecture.find(code: prefecture_code).try(:name)
  end

  def prefecture_name=(prefecture_name)
    self.prefecture_code = JpPrefecture::Prefecture.find(name: prefecture_name).code
  end



  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy # フォロー取得
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy # フォロワー取得
  has_many :following_user, through: :follower, source: :followed # 自分がフォローしている人
  has_many :follower_user, through: :followed, source: :follower # 自分をフォローしている人

  # ユーザーをフォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  # フォローしていればtrueを返す
  def following?(user)
    following_user.include?(user)
  end

  def self.looks(searchs, words) # 検索機能
    if searchs == "perfect_match"
      @user = User.where("name LIKE ?", "#{words}") # 完全一致
    elsif searchs == "forward_match"
      @user = User.where("name LIKE ?", "#{words}%") #前方一致
    elsif searchs == "backward_match"
      @user = User.where("name LIKE ?", "%#{words}") #前方一致
    else
      @user = User.where("name LIKE ?", "%#{words}%") # 部分一致
    end
  end

  attachment :profile_image

  validates :name, presence:true, uniqueness: true, length: { minimum: 2, maximum: 20 }
  validates :introduction, length: { maximum: 50 }

end
