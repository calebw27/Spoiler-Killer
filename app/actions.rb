configure do
  enable :sessions
end

get '/' do
  erb :index
end


get '/login' do
  redirect to("/auth/twitter?force_login=true")
end

get '/auth/twitter/callback' do
  if env['omniauth.auth']
    session[:client] = Twitter::REST::Client.new do |config|
      config.consumer_key = "jBlLVqrNSn7BY48FQFcVu9DjY"
      config.consumer_secret = "Y3hByR3vvFUSlXFouU5xC2eUeoGiqO2TTXJWeu1tUCODyFUK4f"
      config.access_token = request.env['omniauth.auth']['credentials']['token']
      config.access_token_secret = request.env['omniauth.auth']['credentials']['secret']
    end
    redirect to ("/user")
  else
    halt(401,'Not Authorized')
  end
end

get '/auth/failure' do
  params[:message]
end

get '/user' do
  if session[:client]
    erb :'user/index'
  else
    redirect to ("/login")
  end
end

get '/logout' do
  session.clear
  redirect to ("/")
end