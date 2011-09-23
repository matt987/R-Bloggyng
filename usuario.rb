class Usuario
  include MongoMapper::Document

  key :nombre,        String
  key :alias,         String
  key :password,      String
  key :email,         String
  key :fecha_nac,     Date
  #key :post_ids,      Array
  key :seguidores_ids,Array
  key :siguiendo_ids, Array

  timestamps!

  many :posts,      :class_name => 'Post'#,    :in => :post_ids
  many :seguidores, :class_name => 'Usuario', :in => :seguidores_ids
  many :siguiendos,  :class_name => 'Usuario', :in => :siguiendo_ids

  RegEmailName   = '[\w\.%\+\-]+'
  RegDomainHead  = '(?:[A-Z0-9\-]+\.)+'
  RegDomainTLD   = '(?:[A-Z]{2}|com|org|net|gov|mil|biz|info|mobi|name|aero|jobs|museum)'
  RegEmailOk     = /\A#{RegEmailName}@#{RegDomainHead}#{RegDomainTLD}\z/i

  validates_presence_of :nombre
  validates_presence_of :alias
  validates_presence_of :password
  validates_presence_of :email
  validates_presence_of :fecha_nac

  validates_format_of :email, :with => RegEmailOk

  validates_uniqueness_of :alias
  validates_uniqueness_of :email

  #añade un nuevo siguiendo y un seguidor al siguiendo
  def aniadir_siguiendo(seguir)
    siguiendos << seguir
    seguir.seguidores << self
    save
    seguir.save
  end


  #crea un nuevo Post
  def crear_post(text)
    p=Post.create(:text=>text)
    posts << p
    save
  end



  #devuelve el ultimo post
  def last_post
    posts.last
  end

  def siguiendo_posts
    Post.all(:usuario_id.in=> siguiendo_ids,:order => :created_at.desc)
  end


  #Metodo de Clase sin Instancia
  #en caso de loguearse devuelve un Usuario sino nil
  def Usuario.login(aliass,password)
    Usuario.first(:alias=>aliass,:password=>password)
  end




  #protected

  def siguiendo_posts_ids
    p=[]
    siguiendo_ids.each{|s| Usuario.find(s).post_ids.each{ |pid| p << pid}}
    p
  end

end

