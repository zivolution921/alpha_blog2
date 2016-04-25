class ArticlesController < ApplicationController
  
  get '/articles' do
    @articles = Article.all
    auth_erb('articles/article')
  end

  get '/articles/new' do
    @article = Article.new
    auth_erb('articles/create_article')
  end

  post '/articles/new' do
    article = Article.new(:title => params[:title], :description => params[:description])
    if article.valid?
      article.save!
      current_user.articles << article
      current_user.save
      #flash[:notice] = "Article was created"
      auth_redirect("articles/#{article.id}")
      
    else
      session['error'] = article.errors.full_messages.join("\n")
      redirect '/articles/new'
    end
  end

  get '/articles/:id' do
    @article = Article.find(params[:id]) if logged_in?
    auth_erb('articles/show_article')
  end

  delete '/articles/:id' do
    @article = Article.find(params[:id])
    if current_user == @article.author && logged_in?
      @article.destroy
      redirect '/'
    else
      redirect '/login'
    end
  end

  get '/articles/:id/edit' do
    if logged_in?
      @article = Article.find(params[:id])
      if @article.author == current_user
        erb :'articles/edit_article'
      end
    else
      redirect '/login'
    end
  end

  patch '/articles/:id' do
    @article = Article.find(params[:id])

    if @article.update(description: params[:description], title: params[:title])
      auth_erb('articles/show_article')
    else
      session['error'] = @article.errors.full_messages.join("\n")
      redirect "articles/#{params[:id]}/edit"
    end
  end

  helpers do
    def valid_article?(article)
      article.description.length > 0
    end
  end
end