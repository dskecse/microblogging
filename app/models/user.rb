class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@([a-z\d\-]+\.?)+[^.]\.[a-z]+\z/i

  before_save { email.downcase! }

  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }

  has_secure_password
end
