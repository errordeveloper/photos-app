require 'sinatra'
require File.dirname(__FILE__)+'/view'

Thread.new do
  while true
    puts 'updating cached view'
    FlickView::cache_index
    sleep FlickView::UPDATE_INTERVAL
  end
end

get '/' do
  $index
end
