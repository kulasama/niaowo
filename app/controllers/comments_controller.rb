#coding:utf-8
class CommentsController < ApplicationController
  before_filter :authenticate_member!
  skip_before_filter  :verify_authenticity_token,:only => [:create]


  # GET /comments/1
  # GET /coments/1.json
  def show
    @comment = Comment.find(params[:id])
    respond_to do |format|
      format.json { render json: @comment }
      format.xml {render xml: @comment}
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    topic_id = params[:topic].to_i
    @comment = Comment.new(params[:comment])
    @comment.topic_id = topic_id
    @comment.body = params[:body]
    @comment.body.xss_defense!
    @comment.member = current_member
    @comment.topic.incr_view 10

    begin
      @comment.save!
      Feed.comment current_member.id,@comment.id
    rescue => ex
      redirect_to "/topics/#{topic_id}"
      return
    end
    

    @comment.topic.sort_at = Time.now
    
    begin
      @comment.topic.save!
    rescue => ex
    end

    if @comment.topic.member.id != current_member.id
      Feed.commented @comment.topic.member.id,current_member.id,@comment.topic.id
    end

    user_list = []

    @comment.body.scan($AT_USERNAME_REGEX) do |username|
      user_list.push username[0]
    end
    user_list.uniq!

    user_list.each do | username|
      receiver = Member.find_by_username username
      if receiver
        Feed.mention receiver.id,current_member.id,@comment.topic.id
      end
    end

    redirect_to "/topics/#{@comment.topic_id}"
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])

    if @comment.member.id == current_member.id
      @comment.body = params[:body]
      @comment.save()
      mdata = {:status => "success"}
    else
      mdata = {:status => "权限不足"}
    end

    render json:mdata
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    if @comment.member.id == current_member.id
      @comment.deleted = true
      @comment.save
      mdata = {:status => "success"}
    else
      mdata = {:status => "权限不足"}
    end

    render json:mdata
  end
  
  def pei
    Comment.pei params[:id],current_member.id
    mdata = {:status=>"success"}
    render json:mdata
  end


end
