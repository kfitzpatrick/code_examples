class AdvertisersController < ApplicationController

  skip_before_filter :require_privileged

  def index
    @advertisers = current_account.find_advertisers(:all)
  end
  
  def show
    @advertiser = current_account.find_advertisers(params[:id])
    @categories = @advertiser.metrics_by_category
  end
  
  def new
    @advertiser = current_account.build_advertiser
    render :layout => false if request.xhr?
  end
  
  def edit
    @advertiser = current_account.find_advertisers(params[:id])
    render :layout => false if request.xhr?
  end
  
  def create
    @advertiser = current_account.build_advertiser(params[:advertiser])
    if @advertiser.save
      flash[:notice] = "Created Advertiser"
      redirect_to advertiser_url(@advertiser)
    else
      render "new"
    end
  end

  def update
    @advertiser = current_account.find_advertisers(params[:id])
    if @advertiser.update_attributes(params[:advertiser])
      flash[:notice] = "Updated Advertiser"
      redirect_to advertiser_url(@advertiser)
    else
      render "edit"
    end
  end
  
  def destroy
    @advertiser = current_account.find_advertisers(params[:id])
    @advertiser.destroy
    flash[:notice] = %(The advertiser "#{@advertiser.name}" was removed.)
    redirect_to advertisers_url
  end

end
