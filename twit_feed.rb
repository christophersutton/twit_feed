require 'rubygems'
require 'twitter'
require 'sinatra'

def list_data page
   Twitter.list_timeline("sutterbomb","topsecret", options = {:include_entities => 1, :page => page})
end

def timeline_data page
   Twitter.user_timeline("#{params[:user]}", options = {:page => page})
end

def url_pull text
  urls = text.scan %r{(?i)\b((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'".,<>?«»“”‘’]))}
  urls.each &:compact!
end

def get_the_best tweets
  @filtered_data = []
  tweets.each do |i|
    unless url_pull(i["text"]).empty? or i["retweet_count"] == 0
      @filtered_data.push( [ i["text"], i["user"]["screen_name"] + ": " + i["user"]["name"], i["retweet_count"], url_pull(i["text"]) ] )
    end
  end
  @filtered_data.sort! { |a,b| b[2] <=> a[2] }
end

get '/' do
  full_data = list_data(1) + list_data(2) + list_data(3)
  get_the_best(full_data)
  erb :testpartial
end  

get '/:user' do
  full_data = timeline_data(1) + timeline_data(2) + timeline_data(3)
  get_the_best(full_data)
  erb :testpartial
end
