#!/bin/bash
export FLICKR_API_KEY='574f6b47c0033e517a6965463e7920f7'
export FLICKR_SHARED_SECRET='fb187e5434e3d47b'
export FLICKR_USER_ID='31943107@N08'
export FLICKR_UPDATE_INTERVAL='1800'
export FLICKR_COLLECTION_ID='72157631371875950'

export JRUBY_OPTS='-J-Djruby.compile.mode=FORCE -Xcext.enabled=true --server --1.9'

./bin/rackup -s trinidad -p $PORT
