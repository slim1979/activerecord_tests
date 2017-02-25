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
	@authors = Author.all
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
	
	x = Author.where(:name => params[:author_name])	
	@author = Author.find_by_id(x)
	@author.books.create(created_at: Time.now, name: params[:book])	
	
	erb :authors
	
end

get '/authors' do
	erb :authors
end

get '/author/:id' do
	@book = Book.where(author_id: params[:id])
	erb :books
end

get '/logistico' do
	erb :logistico2
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
