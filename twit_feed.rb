require 'rubygems'
require 'sinatra'
require 'sinatra/content_for'
require 'twitter'
require 'readability'
require 'open-uri'
require 'hpricot'

def list_data page
   Twitter.list_timeline("sutterbomb","topsecret", options = {:page => page})
end

def timeline_data page
   Twitter.user_timeline("#{params[:user]}", options = {:page => page})
end

def search_data 
  search = Twitter::Search.new
  search.hashtag("#{params[:hashtag]}").result_type("recent").per_page(15)
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

def get_readable url
  doc = Nokogiri::HTML(open(url))
  doc2 = doc.to_readable
  @title = doc2.search("//h1").first.inner_html
  @summary = doc2.search("#readInner//p").first.inner_html
end


def url_pull text
  urls = text.scan %r{(?i)\b((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))}
  urls.each &:compact!
end

def link_urls_and_users text
  url = /( |^)http:\/\/([^\s]*\.[^\s]*)( |$)/
  user = /@(\w+)/
  while text =~ user
    text.sub! "@#{$1}", "<a href='http://twitter.com/#{$1}'>#{$1}</a>"
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
    unless url_pull(i["text"]).empty? or i["retweet_count"] == 0
      @filtered_data.push( [ link_urls_and_users(i["text"]), 
                          i["user"]["screen_name"], 
                          i["user"]["name"], 
                          i["retweet_count"], 
                          url_pull(i["text"]),
                          i["id"]
                        #  title
                        #  summary
                          ] )
    end
  end
  @filtered_data.sort! { |a,b| b[3] <=> a[3] }
end

get '/' do
  full_data = list_data(1) + list_data(2) + list_data(3)
  get_the_best(full_data)
  erb :home
end  

get '/:user' do
  full_data = timeline_data(1) + timeline_data(2) + timeline_data(3)
  get_the_best(full_data)
  erb :user
end

get '/read/:status_id' do
  get_status
  #get_readable(readable_url(:link))
  erb :read
end

get '/hashtag/:hashtag' do
  get_the_best(search_data)
  erb :home
end
