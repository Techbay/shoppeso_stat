class HomeController < ApplicationController
  def index
    redirect_to "http://www.shoppeso.com/"
  end

  def jump
    History.create(item_id: params[:tid], user_id: params[:cuid], url: params[:u], action_name: "click")
    redirect_to generate_viglink(params)
  rescue
    redirect_to "http://www.shoppeso.com/"
  end

  private
  def generate_viglink(params)
    url = CGI.escape(params[:u])
    uid = CGI.escape(params[:cuid])
    parameters = "key=#{params[:key]}&cuid=#{uid}&u=#{url}" 
    return "http://redirect.viglink.com?#{parameters}"
  end
end
