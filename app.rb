require 'flickraw'
require 'sinatra'
require 'eventmachine'

CDN_PREFIX = 'http://cdnjs.cloudflare.com/ajax/libs/'
CDN = {
  :scripts => [
    "#{CDN_PREFIX}jquery/1.8.0/jquery-1.8.0.min.js",
    "#{CDN_PREFIX}jquery-hashchange/v1.3/jquery.ba-hashchange.min.js",
  ],
}

FlickRaw.api_key = ENV['FLICKR_API_KEY']
FlickRaw.shared_secret = ENV['FLICKR_SHARED_SECRET']

enable :sessions

$user_id = ENV['FLICKR_USER_ID']
# flickr.people.getInfo(:user_id => $user_id).realname
$user_name = flickr.people.getInfo(:user_id => $user_id).username

def fetch_sets
  sets = {}
  flickr.photosets.getList(:user_id => $user_id).each do |ps|
    this = sets[ps.title] = { :id => ps.id, :description => ps.description, :photos => [] }
    flickr.photosets.getPhotos(:photoset_id => ps.id)["photo"].each do |p|
      this[:photos] << { :id => p.id, :url => FlickRaw.url_z(p) }
    end
  end
  return sets
end

## TODO:
# `fetch_sets` takes sometime, but it can become (either):
#   * a cron job that puts it into redis
#   * a background thread that will wake up every once in a while

$sets_hash = fetch_sets
$sets_json = $sets_hash.to_json

get '/' do
  erb :index
end

get '/local_sets.json' do
  content_type 'application/json'
  $sets_json
end
get '/fetch_sets.json' do
  content_type 'application/json'
  fetch_sets.to_json
end
get '/store_sets.json' do
  $sets_hash = fetch_sets
  $sets_json = sets.to_json
end
