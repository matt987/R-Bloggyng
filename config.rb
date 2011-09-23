require 'rubygems'
require 'mongo'
require 'mongo_mapper'
#require "twitter"
MongoMapper.connection = Mongo::Connection.new('10.1.0.104')
MongoMapper.database = 'sampledb'
require 'posts.rb'
require 'usuario.rb'
#require '/home/leandro/Dropbox/mongo_project/twitter.rb'
#Twitter.configure do |config|
#  config.consumer_key = "DVISXbOcMoAJfKmLzZgAaQ"
#  config.consumer_secret = "st6069jNH2gO4uCwZy8ZKldTp92LSzlLCf1BhmBkhXg"
#  config.oauth_token = "174833069-hyojS97gYTBkPam8DM027lPMbP9eNmweKyDgUPhK"
#  config.oauth_token_secret = "rIwhqBCeKxDPKgi4ORuICj0G35KR27Tc3wK8a04SH44"
#end

