require 'rubygems'
require 'mongo'
require 'mongo_mapper'
MongoMapper.connection = Mongo::Connection.new()
MongoMapper.database = 'sampledb'
require 'posts.rb'
require 'usuario.rb'
