#coding:utf-8



class TopicsController < ApplicationController
  before_filter :authenticate_member!
  skip_before_filter  :verify_authenticity_token,:only => [:create]
  # GET /topics
  # GET /topics.json
  def index
    @topics = Topic.where(:deleted => false).order(:viewpoint,:sort_at).reverse_order.page params[:page]
    @new_topic = Topic.new
    
    items = {}
    items['topics'] = []
    @topics.each do | topic |
      data = topic.to_data
      data.delete "body"
      items['topics'].push data
    end
    
    items['page'] = {}
    page = items['page']
    page['total_pages'] = @topics.total_pages
    page['current_page'] = @topics.current_page
    page['total_count'] = @topics.total_count
    
    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: items }
      format.xml {render xml: items}
    end
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
    @topic = Topic.find(params[:id])

    if @topic.deleted
      not_found "topic not exist"
    end

    Topic.pv @topic.id

    unless @topic.view? current_member.id
      @topic.decr_view 1
      @topic.save
      @topic.view current_member.id
    end
    
    @topic.uv  current_member.id
    @comment = Comment.new

    @topic_praise_count = Topic.get_praise @topic.id
    @comments = @topic.get_comments
    
    @users  = [@topic.member.username]
    
    @comments.each do |comment|
      @users.push comment.member.username
    end
    
    @users.uniq!
    
    @users_str = @users.join(",")
    

    items = {}
    items['topic'] = @topic.to_data
    items['comments'] = []
    
    @comments.each do |comment|
      items['comments'].push comment.to_data
    end
    
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: items }
      format.xml {render xml: items}
    end
  end
  


  # POST /topics
  # POST /topics.json
  def create
    @topic = Topic.new(params[:topic])
    @topic.title = params[:title]
    @topic.body = params[:body]
    @topic.body.xss_defense!
    @topic.title.xss_defense!
    @topic.sort_at = Time.now

    @topic.member = current_member

    begin
      @topic.save!
      Feed.topic current_member.id,@topic.id
    rescue => ex
      redirect_to "/topics"
      return
    end


    user_list = []

    @topic.body.scan($AT_USERNAME_REGEX) do |username|
      user_list.push username[0]
    end
    user_list.uniq!


    user_list.each do | username|
      receiver = Member.find_by_username username
      if receiver
        Feed.mention receiver.id,current_member.id,@topic.id
      end
    end

    redirect_to "/topics"
    return
  end

  # PUT /topics/1
  # PUT /topics/1.json
  def update
    @topic = Topic.find(params[:id])
    if @topic.member.id == current_member.id
      @topic.title = params[:title]
      @topic.body = params[:body]
      @topic.sort_at = Time.now
      @topic.save
      mdata = {:status => "success"}
    else
      mdata = {:status => "权限不足"}
    end

    
    render json:mdata
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic = Topic.find(params[:id])
    if @topic.member.id == current_member.id
      @topic.deleted = true
      @topic.save
      mdata = {:status => "success"}
    else
      mdata = {:status => "权限不足"}
    end

    render json:mdata
  end
  
  def pei
    unless Topic.pei? params[:id],current_member.id
      @topic = Topic.find params[:id]
      @topic.decr_view 10
      profile = Profile.find_or_create_by_member_id @topic.member.id
      if profile.sense >= 1
        profile.decr 1
      end
      @topic.save
    end
    Topic.pei params[:id],current_member.id
    mdata = {:status=>"success"}
    render json:mdata
  end

end
