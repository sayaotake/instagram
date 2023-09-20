class CreateTweets < ActiveRecord::Migration[6.1]
  def change
    create_table :tweets do |t|
      t.string :place
      t.string :address
      t.text :review

      t.timestamps
    end
  end
end
