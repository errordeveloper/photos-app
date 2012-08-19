require 'flickraw'
require 'sinatra'
require 'eventmachine'


FlickRaw.api_key = ENV['FLICKR_API_KEY']
FlickRaw.shared_secret = ENV['FLICKR_SHARED_SECRET']

enable :sessions

$user_id = ENV['FLICKR_USER_ID']
# flickr.people.getInfo(:user_id => $user_id).realname
$user_name = flickr.people.getInfo(:user_id => $user_id).username

def fetch_sets
  sets = {}
  flickr.photosets.getList(:user_id => $user_id).each do |ps|
    this = sets[ps.title] = { :description => ps.description, :photos => [] }
    flickr.photosets.getPhotos(:photoset_id => ps.id)["photo"].each do |p|
      this[:photos] << FlickRaw.url_b(p)
    end
  end
  return sets
end

## TODO:
# `fetch_sets` takes sometime, but it can become (either):
#   * a cron job that puts it into redis
#   * a background thread that will wake up every once in a while

$sets = fetch_sets.to_json

get '/' do

  "<!DOCTYPE html>
  <html><head><title>#$user_name</title></head>
  <body>
  <h1>#$user_name's Photography</h1>
  <pre>#$sets</pre>
  </body>
  </html>"
end
