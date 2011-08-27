require 'rubygems'
require 'sinatra'
require 'sinatra/content_for'
require 'twitter'
require 'twitter-text'
include Twitter::Autolink

def homepage_data 
  begin
    Twitter.list_timeline("sutterbomb","topsecret", options = {:per_page => 200, :include_entities => true})
  rescue 
  end
end

def list_data 
  begin
    Twitter.list_timeline("#{params[:username]}","#{params[:list]}", options = {:per_page => 200, :include_entities => true})
  rescue 
  end
end

def username_data 
  begin
    Twitter.user_timeline("#{params[:username]}", options = {:count => 50, :include_entities => true})
  rescue 
  end
end

def hashtag_data
  begin
  Twitter::Search.new.hashtag("#{params[:term]}").filter.fetch
rescue
end
end

# Twitter stops counting after 100 RTs, so I'm changing all '100+' counts to 100 in
# order to sort, then stuffing the '+' back in at the view. Probably a better way 
# to do this, but it should work for now. 
def rt_to_num rt_count
  if rt_count == '100+'
    100
  else
    rt_count
  end
end

def rt_count rt_num
  if rt_num == 100 
    '100+ RT'
else 
  	rt_num.to_s + ' RT'
	end
end

def get_the_best_search tweets
  @filtered_data = []
  unless tweets.nil?
    tweets.each do |i|
      unless URI.extract(i["text"]).empty? 
        @filtered_data.push( [ Twitter.auto_link(i["text"], options = {:username_class => 'test'}), 
        i["from_user"], 
        i["profile_image_url"],
        ] )
      end
    end
  end
end

def get_the_best tweets
  @filtered_data = []
  unless tweets.nil?
    tweets.each do |i|
      unless i["entities"]["urls"].empty? or i["retweet_count"] == 0
        @filtered_data.push( [ Twitter.auto_link(i["text"], options = {:username_class => 'test'}), 
        i["user"]["screen_name"], 
        i["user"]["name"], 
        rt_to_num(i["retweet_count"]),
        i["user"]["profile_image_url"],
        ] )
      end
    end
    # TODO figure out why sorting chokes on the twitter data sometimes. 
    # Using unsorted data for now if it fails.
    begin
      @filtered_data.sort! { |a,b| b[3] <=> a[3] }
    rescue
      @filtered_data
    end  
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
  erb :tweets
end

get '/:username/:list' do
  pass if params[:username] == 'hashtag'
  erb :list
end

post '/:username/:list' do
  pass if params[:username] == 'hashtag'
  get_the_best(list_data)
  erb :tweets
end

get '/hashtag/:term' do
 erb :hashtag
end

post '/hashtag/:term' do
  get_the_best_search(hashtag_data)
  erb :search_tweets
end
