class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i

  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: 'follower_id', dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed

  before_save { email.downcase! }
  before_create :create_remember_token

  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }

  has_secure_password

  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def self.hash(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    Micropost.where('user_id = ?', id)
  end

  def following?(other)
    relationships.find_by(followed_id: other.id)
  end

  def follow!(other)
    relationships.create!(followed_id: other.id)
  end

  def unfollow!(other)
    relationships.find_by(followed_id: other.id).destroy
  end

  private

    def create_remember_token
      self.remember_token = User.hash(User.new_remember_token)
    end
end
