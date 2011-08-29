require 'rubygems'
require 'sinatra'
require 'sinatra/content_for'
require 'twitter'
require 'twitter-text'
include Twitter::Autolink

def description
  begin
    if params[:description] == 'user'
      user = Twitter.user("#{params[:username]}")
      @headline = "<a href=\"http://twitter.com/" + user["screen_name"] + "\">@" + user["screen_name"] + "</a>"
      @description = Twitter.auto_link(user["description"])
    elsif params[:description] == 'list'
      list = Twitter.list("#{params[:username]}","#{params[:list]}")
      @headline = "<a href=\"http://twitter.com" + list["uri"] + "\">" + list["full_name"] + "</a>"
      @description = Twitter.auto_link(list["description"])
    end
  rescue
  end
end

def tweets 
  begin
    if params[:type] == 'user'
      Twitter.user_timeline("#{params[:username]}", options = {:count => 50, :include_entities => true})
    elsif params[:type] == 'list'
      Twitter.list_timeline("#{params[:username]}","#{params[:list]}", options = {:per_page => 200, :include_entities => true})
    end
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

# Playing around with ways to differentiate RT counts - using this to set an 
# opacity on the element right now
def rt_highlight rt_count
  if rt_count == '100+'
    1
  else
    rt_count.to_f / 100
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
    # Not sure if sorting still chokes on the twitter data sometimes. 
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

get '/:username' do
  erb :user
end

get '/:username/:list' do
  erb :list
end

post '/:username' do
  if params[:description] == 'user'
    description
    erb :description, :layout => false
  else
    get_the_best(tweets)
    erb :tweets, :layout => false
  end
end

post '/:username/:list' do
  if params[:description] == 'list'
    description
    erb :description, :layout => false
  else  
    get_the_best(tweets)
    erb :tweets, :layout => false
  end
end

