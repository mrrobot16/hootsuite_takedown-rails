class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :update, :destroy]
  before_action :set_twitter_auth, only: [:create]
  # GET /tweets
  def index
    @tweets = Tweet.all

    render json: @tweets
  end

  # GET /tweets/1
  def show
    render json: @tweet
  end

  # POST /tweets
  def create
    p "tweets_params: ****************>>>>>>>>>>>>>>>>>>>>>>>>>>"
    p tweet_params
    p "tweets_params: ****************>>>>>>>>>>>>>>>>>>>>>>>>>>"
    @tweet = Tweet.new(tweet_params)
    p "<************************>"
    p "@todo.description"
    p @tweet.description
    p "tweet_params:"
    p tweet_params
    p "todo_params.class"
    p tweet_params.class
    p "@twitter_client"
    p @twitter_client
    p "<************************>"
    if @tweet.save
      @twitter_client.update(@tweet.description)
      p "inside if @tweet.save"
      render json: @tweet, status: :created, location: @tweet
    else
      render json: @tweet.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tweets/1
  def update
    if @tweet.update(tweet_params)
      render json: @tweet
    else
      render json: @tweet.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tweets/1
  def destroy
    @tweet.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def tweet_params
      params.require(:tweet).permit(:description, :scheduled)
    end

    def set_twitter_auth
      @twitter_client = Twitter::REST::Client.new do |config|
        config.consumer_key        = ENV["consumer_key"]
        config.consumer_secret     = ENV["consumer_secret"]
        config.access_token        = ENV["access_token"]
        config.access_token_secret = ENV["access_token_secret"]
      end
    end
end
