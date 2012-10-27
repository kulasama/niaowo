#coding:utf-8
class AccountController < Devise::RegistrationsController
  prepend_before_filter :allow_params_authentication!, :only => [:test]
  # GET /resource/sign_up
  def new
    resource = build_resource({})
    respond_with resource
  end

  # POST /resource
  def create
    invite_code = params[:invite_code]
    invite_code.strip! if invite_code
    invite = Invitation.find_by_invite_code params[:invite_code]
    build_resource

    unless invite
      expire_session_data_after_sign_in!
      redirect_to "/account/sign_up",notice:"邀请码错误!"
      return
    end  
    
    if invite.inviter
      expire_session_data_after_sign_in!
      redirect_to "/account/sign_up",notice:"邀请码已被使用!"
      return
    end

    

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        invite.inviter  = resource
        invite.save!
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  # GET /resource/edit
  def edit
    render :edit
  end

    # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    if current_member.valid_password? params[:current_password]
      password = params[:password]
      password_confirmation = params[:password_confirmation]
      if password != password_confirmation
        redirect_to "/account/edit",notice:"两次密码输入不一致"
      else

        if password.size >= 6
          current_member.password=password
          current_member.save
          redirect_to "/account/sign_in",notice:"密码修改成功,请重新登陆"
        else
          redirect_to "/account/edit",notice:"密码太短"
        end


      end

    else
      redirect_to "/account/edit",notice:"密码错误"
    end

  end

  def token
    api_key = params[:api_key]
    api_secret = params[:api_secret]
    username = params[:username]
    password = params[:password]
    if api_key and api_secret and username and password
      if Api.auth(api_key,api_secret)
        begin
          @user = Member.find_by_username username
          if @user.valid_password? password
            sign_in(:member,@user)
            mdata = {:status => "success"}
            render json:mdata
          else
            not_found　"密码错误"
          end
        rescue
          not_found "没有此用户"
        end
      else
        not_found "请检查API KEY"
      end
    else
      not_found "参数不完整"
    end    
  end



end
