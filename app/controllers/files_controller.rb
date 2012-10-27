#coding:utf-8
class FilesController < ApplicationController
  
  before_filter :authenticate_member!
  
  def show
    md5 = params[:md5]
    subfix = params[:subfix]
    filename = "#{md5}.#{subfix}"
    begin
      resource = Resource.find_by_filename filename
      redirect_to resource.get_url
    rescue => ex
      p ex
      not_found "没有资源"
    end
  end
  
  def create    
    data = params[:Filedata]
    if data
      resource = Resource.temp_save data
      if resource
        url = "#{request.base_url}/files/#{resource.filename}"
        type = resource.get_type
        mdata = {:status=>"ok",:url=>url,:type=>type}
      else
        mdata = {:status=>"error"}
      end
    else
      mdata = {:status=>"error"}
    end
    render json:mdata
  end
  
end
