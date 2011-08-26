require 'rubygems'
require 'sinatra'
require 'sinatra/content_for'
require 'twitter'
require 'twitter-text'
include Twitter::Autolink

def homepage_data 
   Twitter.list_timeline("sutterbomb","topsecret", options = {:per_page => 200, :include_entities => true})
end

def list_data 
   Twitter.list_timeline("#{params[:username]}","#{params[:list]}", options = {:per_page => 200, :include_entities => true})
end

def username_data 
   Twitter.user_timeline("#{params[:username]}", options = {:count => 50, :include_entities => true})
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

post '/' do
  get_the_best(homepage_data)
  erb :tweets
end

get '/:username' do
  erb :username
end

post '/:username' do
  get_the_best(username_data)
  erb :tweets
end

get '/:username/:list' do
 erb :list
end

post '/:username/:list' do
  get_the_best(list_data)
  erb :tweets
end
