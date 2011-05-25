require 'rubygems'
require 'readability'
require 'open-uri'
require 'hpricot'


# load document with Nokogiri
 doc = Nokogiri::HTML(open('http://nyti.ms/luE9EY'))

 # set Readability parameters
 doc.read_style = Readability::Style::NEWSPAPER
 doc.read_size = Readability::Size::MEDIUM
 doc.read_margin = Readability::Margin::MEDIUM

 # Print result after Readability has been run
 @readable_content = doc.to_readable

title = @readable_content.search("//h1").first.inner_html
paragraph = @readable_content.search("#readInner//p").first.inner_html
puts title 
puts paragraph