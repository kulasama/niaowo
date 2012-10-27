#coding:utf-8
class TagsController < ApplicationController
  before_filter :authenticate_member!

  # GET /tags/1
  # GET /tags/1.json
  def show
    @tag = Tag.find(params[:id])
    topic_ids = []
    @tag.taggings.each do|tagging|
      topic_ids.push tagging.taggable_id
    end
    @topics = Topic.where(:id => topic_ids)
    @topics = Kaminari.paginate_array(@topics).page params[:page]




    respond_to do |format|
      format.html 
      format.json { render json: @tag }
    end
  end



  # POST /tags
  # POST /tags.json
  def create
    topic = Topic.find params[:topic]
    tag = params[:tag]

    if topic 
      if tag.size > 1 and tag.size < 11  
        current_member.tag(topic, :with => tag, :on => :tags)
        mdata = {:status => "success"}
      elsif tag.size>11 and tag.size <20
        begin
          profile =Profile.find_or_create_by_member_id current_member.id
          profile.decr 1
          current_member.tag(topic, :with => tag, :on => :tags)
          mdata = {:status => "success"}
        rescue
          mdata = {:status =>"no sense"}
        end
      else
        mdata = {:status =>"字数过长"}
      end
    else
      mdata = {:status => "error"}
    end
    render json:mdata
  end

end
