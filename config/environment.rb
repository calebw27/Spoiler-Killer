require 'rubygems'
require 'bundler/setup'

require 'active_support/all'

# Load Sinatra Framework (with AR)
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/contrib/all' # Requires cookies, among other things
require 'omniauth'
require 'omniauth-twitter'
require 'open-uri'
require 'json'
require 'pry'
require 'rack'

APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
APP_NAME = APP_ROOT.basename.to_s

# Sinatra configuration
configure do
  set :root, APP_ROOT.to_path
  set :server, :puma

  enable :sessions
  set :session_secret, ENV['SESSION_KEY'] || 'lighthouselabssecret'

  set :views, File.join(Sinatra::Application.root, "app", "views")
end

# Set up the database and models
require APP_ROOT.join('config', 'database')

# Load the routes / actions
require APP_ROOT.join('app', 'actions')

# OmniAuth configuration
use OmniAuth::Builder do
  provider :twitter, 'jBlLVqrNSn7BY48FQFcVu9DjY', 'Y3hByR3vvFUSlXFouU5xC2eUeoGiqO2TTXJWeu1tUCODyFUK4f'
end

CONSUMER_KEY = OAuth::Consumer.new(
    "jBlLVqrNSn7BY48FQFcVu9DjY",
    "Y3hByR3vvFUSlXFouU5xC2eUeoGiqO2TTXJWeu1tUCODyFUK4f")

ACCESS_TOKEN = OAuth::Token.new(
    "3281135749-UZlpAmLkQNWtPp54x2fKkY7pNpIon1BeToJuUlk",
    "h7mrjRxByDo6SjHzBg2mPCw9paudWj7AUBdRRSkwm4FWK")

