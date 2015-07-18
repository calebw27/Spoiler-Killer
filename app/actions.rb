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

  def get_hashtag_frequency
    hashtag_list = []
    @home_timeline.each do |tweet|
      tweet.hashtags.each do |tag|
        hashtag_list.concat([tag.text])
      end
    end
    @hashtag_frequency = Hash.new(0)
    hashtag_list.each { |tag| @hashtag_frequency[tag] += 1 }
    @hashtag_frequency = @hashtag_frequency.sort_by { |key, value| value }.reverse
  end

  def get_mention_frequency
    mention_list = []
    @home_timeline.each do |tweet|
      tweet.user_mentions.each do |mention|
        mention_list.concat([mention.screen_name])
      end
    end
    @mention_frequency = Hash.new(0)
    mention_list.each { |mention| @mention_frequency[mention] += 1 }
    @mention_frequency = @mention_frequency.sort_by { |key, value| value }.reverse
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
    session[:filters] = []
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
    get_hashtag_frequency
    get_mention_frequency
    erb :'user/index'
  else
    redirect to ("/login")
  end
end

post '/user' do
  session[:filters].concat([params[:filter]])
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
