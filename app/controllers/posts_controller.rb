class PostsController < ApplicationController
  def index
    @posts= Post.order(created_at: :desc)

  end
  def create
    @post = Post.new(post_params)
    if @post.save!
      @posts = Post.count
      respond_to do |format|
        format.turbo_stream
      end 
    end

  end  

  def show
    @post = Post.find(params[:id])
  end
patch "/statuses/:id", to: "statuses#update", as: "status"

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    @posts = Post.count
    respond_to do |format|
      format.turbo_stream
    end
  end

  def edit
    @post = Post.find(params[:id])

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(dom_id(@post), partial: "posts/form", locals: { post: @post }) }
      format.html { render partial: "posts/form", locals: { post: @post } }
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to posts_path, notice: "Article updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end
  
end
