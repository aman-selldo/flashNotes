class User < ApplicationRecord

    has_secure_password

    has_many :subjects, dependent: :destroy 
    has_many :paragraphs, dependent: :destroy
    has_many :questions, through: :paragraphs

    validates :username, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true
end