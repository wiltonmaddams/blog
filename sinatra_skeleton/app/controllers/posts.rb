require 'pry'
require 'pry-nav'

get '/new_post' do
  # Look in app/views/index.erb
  erb :new_post
end

post '/confirm_post' do
  # binding.pry
  # @title = params[:post][:title]
  # @body = params[:post][:body]

  tags = params[:tags].split(' ').map {|tag| tag.gsub(',', '')}
  # binding.pry
  tag_objects = []
  tags.each do |tag|
    if Tag.where(name: tag) != []
      tag_objects << Tag.where(name: tag)[0]
    else
      tag_objects << Tag.create(name: tag)
    end
  end

  @post = Post.create(params[:post])

  tag_objects.each do |tag|
    PostTag.create(tag_id: tag.id, post_id: @post.id)
  end

  erb :index

end

get '/view_post/:post_id' do
 @post = Post.where(id: "#{params[:post_id]}")[0]

  erb :view_post
end

get '/edit_post/:post_id' do
 @post = Post.where(id: "#{params[:post_id]}")[0]

  erb :edit_post
end

post '/update_post' do
  @post = Post.where(id: params[:id])[0]
  @post.tags.each {|tag| tag.destroy}
  PostTag.destroy_all(post_id: params[:id])

  @post.title = params[:title]
  @post.body = params[:body]

  tags = params[:tags].split(' ').map {|tag| tag.gsub(',', '')}
  tag_objects = []
  tags.each do |tag|
    if Tag.where(name: tag) != []
      tag_objects << Tag.where(name: tag)[0]
    else
      tag_objects << Tag.create(name: tag)
    end
  end
  tag_objects.each do |tag|
    PostTag.create(tag_id: tag.id, post_id: @post.id)
  end

  @post.save

  erb :index

end

get '/delete_post/:post_id' do
  @post = Post.where(id: "#{params[:post_id]}")[0]

  @post.tags.each do |tag|
    unless tag.posts.length > 1
      tag.destroy
    end
  end

  @post.destroy
  #we need to delete the records also from the posttags table. tags should only be available for actual records.
  #delete by post_id in posttag table

  erb :index

end

get '/view_by_tag' do

  @tag = Tag.where(name: "#{params[:tag_name]}")[0]

  @posts = @tag.posts

  erb :view_by_tag

end





