class Tweet < ApplicationRecord

    belongs_to :user

    mount_uploader :image, ImageUploader

    has_many :likes, dependent: :destroy
    has_many :liked_users, through: :likes, source: :user
    has_many :comments, dependent: :destroy
    has_many :tweet_tag_relations, dependent: :destroy
    has_many :tags, through: :tweet_tag_relations, dependent: :destroy
    has_many :tweet_topic_relations, dependent: :destroy
    has_many :topics, through: :tweet_topic_relations, dependent: :destroy
    scope :overall_count, -> {order(overall: :desc)}
    scope :most_like, -> { left_joins(:likes).select(:id, "COUNT(likes.id) AS likes_count").group(:id) }
   

end
