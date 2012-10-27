class MemberController < ApplicationController
  before_filter :authenticate_member!
    
  def msg
    mention = Member.get_mention current_member.id
    commented = Member.get_commented current_member.id
    praise = Member.get_praise current_member.id
    sense = Member.get_sense current_member.id

    if mention>0
      Member.clear_mention current_member.id
    end
    if commented >0
      Member.clear_commented current_member.id
    end
    if praise > 0
      Member.clear_praise current_member.id
    end
    if sense > 0 
      Member.clear_sense current_member.id
    end

    mdata ={:mention => mention,
            :commented => commented,
            :praise => praise,
            :sense => sense}
    render json: mdata
  end



  def feeds
    @feeds = Feed.where("member_id in(?)",current_member.id).order(:updated_at).reverse_order.page params[:page]
    @action_type = Feed::ALL_TYPE
  end

  def topics
    @feeds = Feed.where("member_id in(?) and action='topic'",current_member.id).order(:updated_at).reverse_order.page params[:page]
    @action_type = Feed::TOPIC_TYPE
    render "member/feeds.html.haml"
  end

  def comments
    @feeds = Feed.where("member_id in(?) and action='comment'",current_member.id).order(:updated_at).reverse_order.page params[:page]
    @action_type = Feed::COMMENT_TYPE
    render "member/feeds.html.haml"
  end

  def commenteds
    @feeds = Feed.where("member_id in(?) and action ='commented'",current_member.id).order(:updated_at).reverse_order.page params[:page]
    @action_type = Feed::COMMENTED_TYPE
    render "member/feeds.html.haml"
  end

  def ats
    @feeds = Feed.where("member_id in(?) and action='mention'",current_member.id).order(:updated_at).reverse_order.page params[:page]
    @action_type = Feed::MENTION_TYPE
    render "member/feeds.html.haml"
  end

  def praises
    @feeds = Feed.where("member_id in(?) and action in ('topic_praise','comment_praise')",current_member.id).order(:updated_at).reverse_order.page params[:page]
    @action_type = Feed::PRAISE_TYPE
    render "member/feeds.html.haml"
  end


  def search
    q = params[:q].gsub("-","")
    @search = Topic.solr_search do
      fulltext q do 
        highlight :title
        highlight :body
        highlight :comments
        highlight :topic_member
        highlight :comments_member
      end
      order_by :created_at,:desc
      paginate :page => params[:page], :per_page => 10
    end
    @keyword = q
  end




end
