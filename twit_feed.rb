require 'rubygems'
require 'bundler'
require 'sinatra'
require 'sinatra/content_for'
require 'twitter'
require 'open-uri'
require 'nokogiri'

def list_data 
   Twitter.list_timeline("sutterbomb","topsecret", options = {:per_page => 200, :include_entities => true})
end

def timeline_data page
   Twitter.user_timeline("#{params[:user]}", options = {:page => page, :include_entities => true})
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
  @filtered_data.sort! { |a,b| b[3] <=> a[3] }
end

get '/' do
  get_the_best(list_data)
  erb :home
end  

get '/:user' do
  full_data = timeline_data(1) + timeline_data(2) + timeline_data(3)
  get_the_best(full_data)
  erb :user
end
