#coding:utf-8
class PraisesController < ApplicationController
  before_filter :authenticate_member!

  # POST /praises
  # POST /praises.json
  def create
    model_id = params[:model]
    model_type = params[:type]

    if model_type == "topic"
      topic = Topic.find model_id
      if topic
        if topic.member.id == current_member.id
          return render json:{:status=>"forbidden"}
        end
        unless Topic.praised? model_id,current_member.id
           Member.praise topic.member.id
           feed = Feed.new
           feed.member_id = topic.member.id
           feed.action = Feed::TOPIC_PRAISE_TYPE
           feed.data = {
             :sender_id => current_member.id,
             :topic_id => topic.id,
           }
           feed.save!
           topic.incr_view 100
           topic.save

           profile = Profile.find_or_create_by_member_id topic.member.id
           profile.incr 3
        end
        Topic.praise model_id,current_member.id  
        mdata = {:status => "success"}     
      else
        mdata = {:status => "success",:reason=>"未知主题"}  
      end
    elsif model_type == "comment"
      comment = Comment.find model_id
      if comment
        if comment.member.id == current_member.id
          return render json:{:status=>"forbidden"}
        end
        unless Comment.praised? model_id,current_member.id    
          Member.praise comment.member.id
          feed = Feed.new
          feed.member_id = comment.member.id
          feed.action = Feed::COMMENT_PRAISE_TYPE
          feed.data = {
            :sender_id => current_member.id,
            :topic_id => comment.topic.id,
            :comment_id => comment.id
          }
          feed.save!
          profile = Profile.find_or_create_by_member_id comment.member.id
          profile.incr 1
          comment.topic.incr_view 10
          comment.topic.save
        end
        Comment.praise model_id,current_member.id
        mdata = {:status => "success"} 
      end
    else
      mdata = {:status => "success",:reason=>"未知类型"}  
    end


    render json:mdata
  end

end
