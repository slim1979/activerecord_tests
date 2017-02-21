require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/activerecord'

set :database, "sqlite3:test.db"

class Author < ActiveRecord::Base
	has_many :books
end

class Book < ActiveRecord::Base
	belongs_to :author
end

configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Hello stranger'
  end
end

before do
	@authors_list = Author.all
	
end


before '/secure/*' do
  unless session[:identity]
    session[:previous_url] = request.path
    @error = 'Sorry, you need to be logged in to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/' do
  erb :index
end

post '/' do

	@author = Author.where('name=?', params[:author])
	#@author.save
	@book = @author.books.build(name: params[:book])
	@book.save
	@authors = Author.all
	erb :authors
	
end

get '/author/:id' do
	book = Book.where(author_id: params[:id])
	erb "#{book}"
end

get '/login/form' do
  erb :login_form
end

post '/login/attempt' do
  session[:identity] = params['username']
  where_user_came_from = session[:previous_url] || '/'
  redirect to where_user_came_from
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end

get '/secure/place' do
  erb 'This is a secret place that only <%=session[:identity]%> has access to!'
end
