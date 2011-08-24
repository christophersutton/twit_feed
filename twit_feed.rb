require 'rubygems'
require 'bundler'
require 'sinatra'
require 'sinatra/content_for'
require 'twitter'

def list_data 
   Twitter.list_timeline("sutterbomb","topsecret", options = {:per_page => 200, :include_entities => true})
end

def timeline_data 
   Twitter.user_timeline("#{params[:user]}", options = {:count => 50, :include_entities => true})
end

def link_urls_and_users text
  url = /( |^)http:\/\/([^\s]*\.[^\s]*)( |$)/
  user = /@(\w+)/
  while text =~ user
    text.sub! "@#{$1}", "<a class='handle' href='http://twitter.com/#{$1}'>@ #{$1}</a>"
  end
  while text =~ url
    name = $2
    text.sub! /( |^)http:\/\/#{name}( |$)/, " <a href='http://#{name}' >#{name}</a> "
  end
  text
end

def get_the_best tweets
  @filtered_data = []
  tweets.each do |i|
    unless i["entities"]["urls"].empty? or i["retweet_count"] == 0
      @filtered_data.push( [ link_urls_and_users(i["text"]), 
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
#  get_the_best(list_data)
  erb :home
end  

get '/test' do
  get_the_best(list_data)
  erb :test
end

get '/:user' do
  get_the_best(timeline_data)
  erb :user
end
