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
    erb :'user/index'
  else
    redirect to ("/login")
  end
end

get '/logout' do
  session.clear
  redirect to ("/")
end