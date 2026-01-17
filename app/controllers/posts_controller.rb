class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = policy_scope(Post).order(created_at: :desc)
  end

  def show
    authorize @post
  end

  def new
    @post = Post.new
    authorize @post
  end

def create
  @post = current_user.posts.build(post_params)
  authorize @post

  # Decide status from button text
  if params[:commit] == "Save as Draft"
    @post.status = :draft
  elsif params[:commit] == "Publish"
    @post.status = :published
  else
    @post.status = :draft   # fallback
  end

  if @post.save
    if @post.draft?
      redirect_to edit_post_path(@post), notice: "Draft saved successfully."
    else
      redirect_to @post, notice: "Post published successfully."
    end
  else
    render :new, status: :unprocessable_entity
  end
end

  def edit
    authorize @post
  end

def update
  authorize @post

  # Decide status from button text
  if params[:commit] == "Save as Draft"
    @post.status = :draft
  elsif params[:commit] == "Publish"
    @post.status = :published
  end

  if @post.update(post_params)
    if @post.draft?
      redirect_to edit_post_path(@post), notice: "Draft updated."
    else
      redirect_to @post, notice: "Post updated and published."
    end
  else
    render :edit, status: :unprocessable_entity
  end
end

  def destroy
    authorize @post
    @post.destroy
    redirect_to posts_url, notice: "Post was successfully destroyed."
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end
end