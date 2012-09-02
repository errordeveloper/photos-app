require 'erb'
require 'flickraw'

class FlickView

  CDN_PREFIX = 'http://cdnjs.cloudflare.com/ajax/libs/'
  CDN = {
    :scripts => [
      "#{CDN_PREFIX}jquery/1.8.0/jquery-1.8.0.min.js",
      "#{CDN_PREFIX}jquery-hashchange/v1.3/jquery.ba-hashchange.min.js",
    ],
  }

  UPDATE_INTERVAL = ENV['FLICKR_UPDATE_INTERVAL'].to_i

  FlickRaw.api_key = ENV['FLICKR_API_KEY']
  FlickRaw.shared_secret = ENV['FLICKR_SHARED_SECRET']

  USER_ID = ENV['FLICKR_USER_ID']
  COLLECTION_ID = ENV['FLICKR_COLLECTION_ID']

  def initialize
    index!
  end
  def index
    return @index
  end
  def index!
    @user_name = flickr.people.getInfo(:user_id => USER_ID).username
    @sets_hash = {}
    flickr.collections.getTree(:user_id => USER_ID, :collection_id => COLLECTION_ID).first.set.each do |ps|
      this = @sets_hash[ps.title] = { :id => ps.id, :description => ps.description, :photos => [] }
      flickr.photosets.getPhotos(:photoset_id => ps.id)["photo"].each do |p|
        this[:photos] << { :id => p.id, :url => FlickRaw.url_z(p) }
      end
    end
    @index = ERB.new(File.read('./index.erb')).result(binding())
  end
end
