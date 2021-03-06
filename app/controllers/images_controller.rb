class ImagesController < ApplicationController
  before_filter :authenticate_user!
  helper_method :image, :images, :effect

  # GET /images
  # GET /images.json
  def index
  end

  # GET /images/1
  # GET /images/1.json
  def show
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # GET /images/1/edit
  def edit
  end

  # GET /effects/images/1
  def select
  end

  # POST /effects/1/apply-effect/1
  def apply_effect
    image.apply_effect(effect)
    image.save!
    redirect_to images_selection_path(effect)
  end

  # GET /users/1/images
  def user_index
    images = user.images
  end

  # GET /users/1/image
  def shared
    images = current_user.shared_images
  end

  # POST /images/1/trash
  def trash_image
    image.in_trash = true
    image.save
    redirect_to images_path
  end

  # GET images/trashed-images
  def trashed_images
    @images = Image.where( in_trash: true, owner: current_user )
  end

  # POST /images/1/untrash
  def untrash_image
    image.in_trash = false
    image.save
    redirect_to images_path
  end

  # POST /trash/empty-trash
  def empty_trash
    images.each do |image| if image.owner == current_user then image.destroy end end
    redirect_to images_path
  end

  # PATCH images/1/make-current
  def make_current
    unless image.root_version?
      image.make_current
      image.v = 0
      image.save
    end
    redirect_to image_path image
  end
  
  # POST /images
  # POST /images.json
  def create
    @image = Image.new(image_params)
    @image.owner = current_user
    @image.in_trash = false

    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: 'Image was successfully created.' }
        format.json { render :show, status: :created, location: @image }
      else
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /images/1
  # PATCH/PUT /images/1.json
  def update
    respond_to do |format|
      if image.update(image_params)
        format.html { redirect_to image, notice: 'Image was successfully updated.' }
        format.json { render :show, status: :ok, location: image }
      else
        format.html { render :edit }
        format.json { render json: image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    #If image has parent, update children and vice versa
    if image.root_version? then
      newroot = image.child_versions.order(:created_at).last
      image.child_versions.delete(newroot)
      image.child_versions.each do |v| v.parent_image = newroot and v.save end
    else
      image.child_versions.each do |v| v.parent_image = image.parent_image and v.save end
    end

    image.destroy
    respond_to do |format|
      format.html { redirect_to images_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def image
    @image  ||= Image.find(params[:id])
  end

  def images
    @images ||= Image.all
  end

  def effect
    @effect ||= Effect.find(params[:effect_id]) 
  end

  def user
    @user   ||= User.find(params[:user_id])
  end


  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def image_params
      params.require(:image).permit(:title, :caption, :image, :owner, :in_trash, :parent_image, :child_versions, :v)
    end
end
