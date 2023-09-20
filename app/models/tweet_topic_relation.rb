class TweetTopicRelation < ApplicationRecord
  belongs_to :tweet
  belongs_to :topic
end
