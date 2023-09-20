class TweetsController < ApplicationController

    before_action :authenticate_user!, only: [:new, :create]

    def top
      @tweets= Tweet.all
      @topics = Topic.all
      search = params[:search]
      @tweets = Tweet.joins(:user).where("place LIKE ? OR address LIKE ?", "%#{search}%", "%#{search}%")
          #もしタグ検索したら、tweet_idsにタグを持ったidをまとめてそのidで検索
          if params[:tag_id].present?
              tweet_ids = []
              @tag = Tag.select("name", "id")
              tag_id = params[:tag_id]
                  if tag_id != nil
                      @tweets = Tag.find_by(id: tag_id).tweets
                  else
                      @tweets = Tweet.all
                  end
              tweet_ids = tweet_ids.uniq
                  #キーワードとチェックボックスのAND検索
              @tweets = @tweets.where(id: tweet_ids) if tweet_ids.present?
          end

          if params[:topic_ids].present?
              tweet_ids = []
              params[:topic_ids].each do |key, value| 
              if value == "1"
                  Topic.find_by(name: key).tweets.each do |p| 
                  tweet_ids << p.id
                  end
              end
              end
              tweet_ids = tweet_ids.uniq
                  #キーワードとタグのAND検索
              @tweets = @tweets.where(id: tweet_ids) if tweet_ids.present?
          end
    end
    

    def index
      @tweets= Tweet.all
      @topics = Topic.all
      search = params[:search]
      @tweets = Tweet.joins(:user).where("place LIKE ? OR address LIKE ?", "%#{search}%", "%#{search}%")
          #もしタグ検索したら、tweet_idsにタグを持ったidをまとめてそのidで検索
          if params[:tag_id].present?
              tweet_ids = []
              @tag = Tag.select("name", "id")
              tag_id = params[:tag_id]
                  if tag_id != nil
                      @tweets = Tag.find_by(id: tag_id).tweets
                  else
                      @tweets = Tweet.all
                  end
              tweet_ids = tweet_ids.uniq
                  #キーワードとチェックボックスのAND検索
              @tweets = @tweets.where(id: tweet_ids) if tweet_ids.present?
          end

          if params[:topic_ids].present?
              tweet_ids = []
              params[:topic_ids].each do |key, value| 
              if value == "1"
                  Topic.find_by(name: key).tweets.each do |p| 
                  tweet_ids << p.id
                  end
              end
              end
              tweet_ids = tweet_ids.uniq
                  #キーワードとタグのAND検索
              @tweets = @tweets.where(id: tweet_ids) if tweet_ids.present?
          end

          if params[:overall_count]
            @tweets = Tweet.overall_count
       elsif params[:sort]
           @tweets = Tweet.most_like.order("likes_count DESC").select("tweets.*")
       end

    end
    
    def new
        @tweet = Tweet.new
      end
    
      def create
        tweet = Tweet.new(tweet_params)

        tweet.user_id = current_user.id 

        if tweet.save!
          redirect_to :action => "index"
        else
          redirect_to :action => "new"
        end
      end

      def show
        @tweet = Tweet.find(params[:id])
        @comments = @tweet.comments
        @comment = Comment.new
      end

      def edit
        @tweet = Tweet.find(params[:id])
      end
    
      def update
        tweet = Tweet.find(params[:id])
        if tweet.update(tweet_params)
          redirect_to :action => "show", :id => tweet.id
        else
          redirect_to :action => "new"
        end
      end

      def destroy
        tweet = Tweet.find(params[:id])
        tweet.destroy
        redirect_to action: :index
      end

      private
      def tweet_params
        params.require(:tweet).permit(:place, :address, :review, :image, :overall,:tag_ids,:lat,:lng,topic_ids:[])
    end

end
