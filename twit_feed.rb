require 'rubygems'
require 'bundler'
require 'sinatra'
require 'sinatra/content_for'
require 'twitter'
require 'twitter-text'
include Twitter::Autolink

def list_data 
   Twitter.list_timeline("sutterbomb","topsecret", options = {:per_page => 200, :include_entities => true})
end

def timeline_data 
   Twitter.user_timeline("#{params[:user]}", options = {:count => 50, :include_entities => true})
end

def get_the_best tweets
  @filtered_data = []
  
  tweets.each do |i|
    unless i["entities"]["urls"].empty? or i["retweet_count"] < 2
      @filtered_data.push( [ Twitter.auto_link(i["text"], options = {:username_class => 'test'}), 
                          i["user"]["screen_name"], 
                          i["user"]["name"], 
                          i["retweet_count"], 
                          ] )
    end
  end
  # TODO figure out why this chokes on the twitter data sometimes. 
  # Using unsorted data for now if it fails.
  begin
    @filtered_data.sort! { |a,b| b[3] <=> a[3] }
  rescue
    @filtered_data
  end  
end

get '/' do
  erb :home
end  

get '/list' do
  get_the_best(list_data)
  erb :tweets
end

get '/:user' do
  erb :user
end

post '/:user' do
  get_the_best(timeline_data)
  erb :tweets
end

