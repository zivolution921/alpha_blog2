require './config/environment'


class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "alpha blog secret"
  end

  get '/' do
    @articles = Article.all
    erb :"articles/index"
  end
  
  get '/signup' do 
    if logged_in? 
      redirect '/'
    else
      erb :'users/create_user'
    end
  end
  
  post '/signup' do 
    user =  Author.new(:username => params[:username], :email => params[:email], :password => params[:password])
    if user.save && valid_user?(user)
      session[:user_id] = user.id
      redirect '/'
    else
      redirect '/signup'
    end
  end
  
  get '/login' do 
    if logged_in? 
      redirect '/articles'
    else
      erb :'/users/login'
    end
  end
  
  post '/login' do 
    user = Author.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/articles'
    else
      redirect '/login'
    end
  end
  
  get '/logout' do 
    if logged_in? 
      session.clear
      redirect '/login'
    else
      redirect '/'
    end
  end
      
  
  helpers do 
    def logged_in?
      !!session[:user_id]
    end
    
    def current_user
      Author.find(session[:user_id])
    end
    
    def auth_redirect(path)
      logged_in? ? (redirect path ) : (redirect '/login')
    end
    
    def auth_erb(path)
      logged_in? ? (erb :"#{path}") : (redirect '/login')
    end
    
    def valid_user?(user)
      user.username.length > 0 && user.email.length > 0 && user.password.length > 0
    end
  end
end