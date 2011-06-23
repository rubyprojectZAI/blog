require 'RMagick'
require 'webrick/httputils'

list = WEBrick::HTTPUtils.load_mime_types('/etc/mime.types')
Rack::Mime::MIME_TYPES.merge!(list)

class PostsController < ApplicationController
  # GET /posts
  # GET /posts.xml

  before_filter :confirm_logged_in, :except => [:show, :index]
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

    @user = User.find_by_login(session[:login])
    @post = @user.posts.create!(params[:post])
    slajd = Post.convert_to_pdf(params[:upload], @post.id)
    video = Post.save_video(params[:upload_video], @post.id)

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

  def rate
    
    @post = Post.find(params[:id])


    if cookies[:rates].blank?
      change_rate = true
    else
      i = 0
      while i < cookies[:rates].length do
      if cookies[:rates][i] == @post.id.to_s()
        change_rate = false
      else
        change_rate = true
      end

      puts cookies[:rates][i]
      i += 1
    end
    end
    

    if change_rate == true

      badrate = @post.badrate
      if badrate == nil
      badrate = 1
      else
      badrate = badrate +1
      end
      @post.badrate = badrate
      @post.save

      if cookies[:rates].blank?
        cookies[:rates] = [@post.id]
      else
        cookies[:rates] = cookies[:rates] + @post.id.to_s()
      end
    end

    @tekst = @post.badrate
    

    respond_to do |format|
    # format.html # show.html.erb
      format.js
    end
  end

  def rategood

    @post = Post.find(params[:id])

    if cookies[:rates].blank?
      change_rate = true
    else
      i = 0
      while i < cookies[:rates].length do
      if cookies[:rates][i] == @post.id.to_s()
      change_rate = true
      else
      change_rate = false
      end

      puts cookies[:rates][i]
      i += 1
    end
    end
    

    if change_rate == true

      goodrate = @post.goodrate
      if goodrate == nil
      goodrate = 1
      else
      goodrate = goodrate +1
      end
      @post.goodrate = goodrate
      @post.save

      if cookies[:rates].blank?
        cookies[:rates] = [@post.id]
      else
        cookies[:rates] = cookies[:rates] + @post.id.to_s()
      end
    end

    @tekst = @post.goodrate

    respond_to do |format|
    # format.html # show.html.erb
      format.js
    end
  end

end
