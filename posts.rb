class Post
  include MongoMapper::Document



  key :text,        String
  key :usuario_id, ObjectId
  belongs_to :usuario
  timestamps!

  scope :siguiendos, lambda{ |array| where(:_id.in => array)}


end

