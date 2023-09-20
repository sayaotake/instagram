class CreateTweetTopicRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :tweet_topic_relations do |t|
      t.references :tweet, null: false, foreign_key: true
      t.references :topic, null: false, foreign_key: true

      t.timestamps
    end
  end
end
