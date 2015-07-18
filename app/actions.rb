configure do
  enable :sessions
end

helpers do

  def get_client
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = "jBlLVqrNSn7BY48FQFcVu9DjY"
      config.consumer_secret = "Y3hByR3vvFUSlXFouU5xC2eUeoGiqO2TTXJWeu1tUCODyFUK4f"
      config.access_token = session[:access_token]
      config.access_token_secret = session[:access_token_secret]
    end
    @client
  end

  def get_lists
    @hashtag_list = []
    @mention_list = []
    @user_list = []
    @home_timeline.each do |tweet|
      @user_list.concat([tweet.user.screen_name])
      tweet.hashtags.each do |tag|
        @hashtag_list.concat(["#".concat(tag.text)])
      end
      tweet.user_mentions.each do |mention|
        @mention_list.concat(["@".concat(mention.screen_name)])
      end
    end
  end

  def get_hashtag_frequency
    @hashtag_frequency = Hash.new(0)
    @hashtag_list.each { |tag| @hashtag_frequency[tag] += 1 }
    @hashtag_frequency = @hashtag_frequency.sort_by { |key, value| value }.reverse
  end

  def get_mention_frequency
    @mention_frequency = Hash.new(0)
    @mention_list.each { |mention| @mention_frequency[mention] += 1 }
    @mention_frequency = @mention_frequency.sort_by { |key, value| value }.reverse
  end

  def get_user_frequency
    @user_frequency = Hash.new(0)
    @user_list.each { |user| @user_frequency[user] += 1 }
    @user_frequency = @user_frequency.sort_by { |key, value| value }.reverse
  end

  def reset_filters
    session[:filters] = {hashtags: [], mentions: [], users: [], content: []}
  end

end

get '/' do
  erb :index
end

get '/login' do
  redirect to("/auth/twitter?force_login=true")
end

get '/auth/twitter/callback' do
  if env['omniauth.auth']
    session[:logged_in] = true
    reset_filters
    session[:access_token] = request.env['omniauth.auth']['credentials']['token']
    session[:access_token_secret] = request.env['omniauth.auth']['credentials']['secret']
    redirect to ("/user")
  else
    halt(401,'Not Authorized')
  end
end

get '/auth/failure' do
  params[:message]
end

get '/user' do
  if session[:logged_in]
    @client = get_client
    @home_timeline = @client.home_timeline({count: 200})
    get_lists
    get_hashtag_frequency
    get_mention_frequency
    get_user_frequency
    erb :'user/index'
  else
    redirect to ("/login")
  end
end

post '/user' do
  binding.pry
  case
  when params[:reset_filters]
    reset_filters
  when params[:hashtag] 
    session[:filters][:hashtags].concat([params[:hashtag]])
  when params[:mention] 
    session[:filters][:mentions].concat([params[:mention]])
  when params[:user] 
    session[:filters][:users].concat([params[:user]])
  end
  binding.pry
  redirect to ("/user")
end

get '/logout' do
  session.clear
  redirect to ("/")
end

get '/compose' do
  erb :'compose'
end

post '/newtweet' do
  if session[:logged_in]
    @client = get_client
    @client.update(params[:compose_tweet])
    redirect to ('/user')
  end
end
