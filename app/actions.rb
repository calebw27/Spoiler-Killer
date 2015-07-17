configure do
  enable :sessions
end

# Homepage (Root path)

get '/' do
  erb :index
end


get '/login' do
  redirect to("/auth/twitter?force_login=true")
end

get '/auth/twitter/callback' do
  if env['omniauth.auth']
    session[:user] = request.env['omniauth.auth']['info']['name']
    session[:token] = request.env['omniauth.auth']['credentials']['token']
    session[:secret] = request.env['omniauth.auth']['credentials']['secret']
    session[:img] = request.env['omniauth.auth']['info']['image']
    # binding.pry
    redirect to ("/user")
  else
    halt(401,'Not Authorized')
  end
end

get '/auth/failure' do
  params[:message]
end

get '/user' do
  if session[:user]
    url = URI("https://api.twitter.com/1.1/statuses/home_timeline.json")
    twitter_request = Net::HTTP::Get.new url.request_uri
    http = Net::HTTP.new url.host, url.port
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    twitter_access_token = OAuth::Token.new(session[:token], session[:secret])
    twitter_request.oauth! http, CONSUMER_KEY, twitter_access_token
    http.start
    twitter_response = http.request twitter_request
    @twitter_timeline = JSON.parse(twitter_response.body)
    erb :'user/index'
  else
    redirect to ("/login")
  end
end

get '/logout' do
  session.clear
  redirect to ("/")
end