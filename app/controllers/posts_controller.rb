class PostsController < ApplicationController

  before_action :set_post, only: [:show, :edit, :update, :destroy]
  
  def index
    @posts = Post.all
  end

  def new

      @post = Post.new
      @images = @post.images.build

    
    @category_parent_array = ["---"]
#データベースから、親カテゴリーのみ抽出し、配列化
      Category.where(ancestry: nil).each do |parent|
         @category_parent_array << parent.name
      end
  end

  def get_category_children
    #選択された親カテゴリーに紐付く子カテゴリーの配列を取得
    @category_children = Category.find_by(name: "#{params[:parent_name]}", ancestry: nil).children
 end

 # 子カテゴリーが選択された後に動くアクション
 def get_category_grandchildren
#選択された子カテゴリーに紐付く孫カテゴリーの配列を取得
    @category_grandchildren = Category.find("#{params[:child_id]}").children
 end

  



  def create
    @post = Post.new(post_params)

    if @post.save

      params[:images]['image'].each do |img|
        @images = @post.images.create(image: img, post_id: @post.id)
      end
      redirect_to posts_url
    else
      # redirect_to new_post_path
      @images = @post.images.build
      @category_parent_array = ["---"]
      Category.where(ancestry: nil).each do |parent|
        @category_parent_array << parent.name
     end

        


     render action: :new
    end  
  end

  def show
    # @post =Post.find(params[:id])
    @images = @post.images

 

  end

  def destroy
    # @post = Post.find(params[:id])
    @post.destroy
    redirect_to("/")
  end

  def edit
    # @post = Post.find(params[:id])
    # 選択された子カテゴリーに紐付く孫カテゴリーの配列を取得
    @category_parent_array = ["---"]
    #データベースから、親カテゴリーのみ抽出し、配列化
    Category.where(ancestry: nil).each do |parent|
        @category_parent_array << parent.name
    end
  end
    
    def get_category_children
      #選択された親カテゴリーに紐付く子カテゴリーの配列を取得
      @category_children = Category.find_by(name: "#{params[:parent_name]}", ancestry: nil).children
    end
  
    # 子カテゴリーが選択された後に動くアクション
    def get_category_grandchildren
    #選択された子カテゴリーに紐付く孫カテゴリーの配列を取得
      @category_grandchildren = Category.find("#{params[:child_id]}").children
    end

  def update
    # @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path, notice: ''
    else
      #updateを失敗すると編集ページへ
      @category_parent_array = ["---"]
      Category.where(ancestry: nil).each do |parent|
        @category_parent_array << parent.name
      end
      render 'edit'
    end
  end



  private
  def post_params
    params.require(:post).permit(:item_name,:description,:sales_status,:brand,:size,:condition,:price,:shipping_area,:arrival_days,:postage_payment,:posts_status,:category_id,images_attributes: [:id,:image]).merge(user_id: current_user.id,category_id:params[:category_id])
  end

  def set_post
    @post = Post.find(params[:id])
  end
end

