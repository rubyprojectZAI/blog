require 'RMagick'
class Post < ActiveRecord::Base
	
	has_many :comments
	belongs_to :user
	
	validates_presence_of :title, :body
	
	# before_save :save_scene
# 	
	# attr_protected  :scenevalue
	
	def self.convert_to_pdf(upload="", newpost)
		name =  upload['datafile'].original_filename
		directory = "public/images"
		# create the file path
		path = File.join(directory, name)
		# write the file
		File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
		
		updated_post = Post.find(newpost)
		
		pdf = Magick::ImageList.new("public/images/#{name}")
    pdf.write("public/images/post-#{updated_post.id}slajd.jpg")
    
    
    # scenevalue = pdf.scene if scene.blank?
    updated_post.scene = pdf.scene
    updated_post.save
    
	end
	def self.save_video(upload="", newpost)
    name =  upload['datafile'].original_filename
    directory = "public/images"
    # create the file path
    path = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
    
    updated_post = Post.find(newpost)

    updated_post.video = path
    updated_post.save
    
  end
	
	private
	
	# def save_scene
	  # unless scene.blank?
      # self.scene = scenevalue
    # end
# 	  
	# end
	
	
	# def self.convertpdf(path="")
	  # pdf = Magick::Image.read(path)
	  # # image = Magick::
    # pdf.write("myimage.jpg")
	# end
end
