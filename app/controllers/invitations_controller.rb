class InvitationsController < ApplicationController
  before_filter :authenticate_member!


  # GET /invitations
  # GET /invitations.json
  def index
    @invitions_size = Invitation.all.size
    @invitations = current_member.invitations.order(:updated_at).reverse_order.page params[:page]  
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @invitations }
    end
  end




 

  # POST /invitations
  # POST /invitations.json
  def create

    profile =  Profile.find_or_create_by_member_id current_member.id
    if profile.sense < 1
      mdata = {:status=>"nosense"}
    elsif current_member.invitations.size >= Invitation::MEMBER_SIZE
      mdata = {:status=>"nopersoninv"}
    elsif Invitation.all.size >= Invitation::MAX_SIZE
      mdata = {:status=>"noinv"}
    else
      @invitation = Invitation.generate current_member
      mdata = {:status=>"success",:invite_code => @invitation.invite_code}
    end
    render json:mdata
  end


end
