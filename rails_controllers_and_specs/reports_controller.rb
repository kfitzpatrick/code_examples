class ReportsController < ApplicationController

  skip_before_filter :require_privileged

  def index
    @reports = Report.search_by_account(current_account, params)
  end
  
  def show
    @report = current_account.find_reports(params[:id])
    @report.set_start_and_end_date(params[:start], params[:end]) if params[:start] and params[:end]
    respond_to do |format|
      format.html
      format.xls { send_data @report.to_xls, :filename => "#{@report.name}.xls", :type => Mime::XLS }
    end
  end
  
  def new
    @report = current_account.build_report
    @report.advertiser = current_account.find_advertiser_by_id(params[:advertiser_id])
    render :layout => false if request.xhr?
  end
  
  def edit
    @report = current_account.find_reports(params[:id])
    render :layout => false if request.xhr?
  end
  
  def create
    @report = current_account.build_report(params[:report])
    if @report.save
      flash[:notice] = "Created Report"
      redirect_to report_url(@report)
    else
      render "new"
    end
  end

  def update
    @report = current_account.find_reports(params[:id])
    if @report.update_attributes(params[:report])
      flash[:notice] = "Updated Report"
      redirect_to report_url(@report)
    else
      render "edit"
    end
  end
  
  def destroy
    @report = current_account.find_reports(params[:id])
    @report.destroy
    flash[:notice] = %(The report "#{@report.name}" was removed.)
    redirect_to reports_url
  end

end
