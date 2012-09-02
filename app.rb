require 'sinatra'
require File.dirname(__FILE__)+'/view'

$FlickView = FlickView.new

Thread.new do
  while true
    puts 'updating cached view'
    $FlickView.index!
    sleep FlickView::UPDATE_INTERVAL
  end
end

get '/' do
  $FlickView.index
end
