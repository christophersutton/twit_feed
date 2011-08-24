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

def url_pull text
  urls = text.scan %r{(?i)\b((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))}
  urls.each &:compact!
end

def get_status 
  tweet = Twitter.status("#{params[:status_id]}").text
  url = url_pull(tweet).first.to_s
  doc = Nokogiri::HTML(open(url))
  doc2 = doc.to_readable
  @title = doc2.search("//h1").first.inner_html
  @summary = doc2.search("#readInner//p").first.inner_html
  @doc = doc2
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
