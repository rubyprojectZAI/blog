require 'RMagick'
class PostsController < ApplicationController
  # GET /posts
  # GET /posts.xml
  # def initialize
    # # session[:slajd] = 0
  # end
  attr_accessor :numer_slajdu
  
  def index
    @posts = Post.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    
    @post = Post.find(params[:id])
    @image_post = @post.id
    @page = 0
    @presentation_max_number = @post.scene
    @video_path = @post.video
    @autor = @post.user.login
    @created = @post.created_at
    # @image_path = "/images/post-#{@post.id}slajd-#{@page}.jpg"

    session[:slajd] = 0
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create

    # Post.transaction do
      # slajd = Post.convert_to_pdf(params[:upload])
      @user = User.find_by_login(session[:login])
      @post = @user.posts.create!(params[:post])
      slajd = Post.convert_to_pdf(params[:upload], @post.id)
      video = Post.save_video(params[:upload_video], @post.id)
    # end
    
    
    # slajd = Post.convert_to_pdf(params[:upload])
    # @user = User.find_by_login(session[:login])
    # @post = @user.posts.create!(params[:post])
    
    # @post = Post.new(params[:post])
    # pdf = Post.convert_pdf(params[:upload])
    #############################################################
    
    # name =  params[:upload]['datafile'].original_filename
    # directory = "upload/public/data"
    # # create the file path
    # path = File.join(directory, name)
    # # write the file
    # File.open(path, "wb") { |f| f.write(params[:upload]['datafile'].read) }
#     
    # pdf = Magick::ImageList.new("upload/public/data/#{name}")
    # pdf.write("upload/public/data/post-#{@post.id}slajd.jpg")
    
    #############################################################

    respond_to do |format|
      if @post.save
        format.html { redirect_to(@post, :notice => 'Post was successfully created.') }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        format.html { redirect_to(@post, :notice => 'Post was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
  
   def uploadFile
    post = DataFile.save(params[:upload])
    render :text => "File has been uploaded successfully"
  end 
  def show_image
    puts "dziala"
    @post = Post.find(params[:id])
    
    if session[:slajd] == nil
      puts session[:login]
     puts session[:slajd] = 0
    end

     puts session[:slajd] = session[:slajd] + 1

    
    # session[:slajd] = session[:slajd].to_i + 1
    @page = session[:slajd].to_s
    @image_path = "/images/post-#{@post.id}slajd-#{@page}.jpg"
    @image_post = 
    # if numer_slajdu == nil
      # numer_slajdu = 0
    # end
#     
    # numer_slajdu = numer_slajdu + 1
    
    # @image_path = "/images/post-#{@post.id}slajd-#{numer_slajdu}.jpg"
    
    respond_to do |format|
      format.html # show.html.erb
      format.js  
      # { render :xml => @image_paths }
    end
  end
  
end
