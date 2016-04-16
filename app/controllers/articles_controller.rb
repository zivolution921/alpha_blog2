class ArticlesController < ApplicationController
  
  get '/articles' do
    @articles = Article.all
    auth_erb('articles/article')
  end

  get 'articles/new' do
    auth_erb('articles/create_article')
    #@article = Article.new
  end

  post '/articles/new' do
    article = Article.new(:description => params[:description])
    if valid_artile?(article)
      article.save
      current_user.articles << article
      current_user.save
      auth_redirect("articles/#{article.id}")
      flash[:notice] = "Article was created"
    else
      redirect '/articles/new'
    end
  end

  get 'articles/:id' do
    @article = Article.find(params[:id]) if logged_in?
    auth_erb('articles/show_article')
  end

  delete '/articles/:id/delete' do
    @article = Article.find(params[:id])
    if current_user == @article.user && logged_in?
      @article.delete
      redirect '/article'
    else
      redirect '/login'
    end
  end

  get '/articles/:id/edit' do
    if logged_in?
      @article = Article.find(params[:id])
      if @article.user == current_user
        erb :'articles/edit_article'
      end
    else
      redirect '/login'
    end
  end

  patch '/articles/:id' do
    @article = Article.find(params[:id])
    if params[:description].length > 0
      article.update(:description => params[:description])
      auth_erb('articles/show_article')
    else
      redirect 'articles/#{params[:id]}/edit'
    end
  end

  helpers do
    def valid_article?(article)
      article.description.length > 0
    end
  end
end