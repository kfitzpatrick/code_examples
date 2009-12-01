require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ReportsController do
  mock_models :report, :advertiser

  as_authenticated_only :get => :index do
    before { Report.should_receive(:search_by_account).and_return([mock_report]) }
    it { should respond_with(:success) }
  end

  as_authenticated_only :get => :new, :advertiser_id => '43' do
    before { @current_account.should_receive(:build_report).and_return(mock_report) }
    before { @current_account.should_receive(:find_advertiser_by_id).with('43').and_return(mock_advertiser) }
    before { mock_report.should_receive(:advertiser=).with(mock_advertiser) }

    it { should respond_with(:success) }
  end

  as_authenticated_only :get => :edit, :id => '12' do
    before { @current_account.should_receive(:find_reports).with('12').and_return(mock_report) }
    it { should respond_with(:success) }
  end

  as_authenticated_only :get => :show, :id => '12' do
    before do
      @current_account.should_receive(:find_reports).with('12').and_return(mock_report)
    end

    describe Mime::HTML do
      it { should respond_with(:success) }
      it { should assign_to(:report, :with => mock_report) }
    end

    describe Mime::XLS do
      before do
        mock_report.should_receive(:to_xls).and_return('xls;file;blah')
        mock_report.should_receive(:name).and_return("Foo")
      end

      it { should respond_with(:success).body('xls;file;blah').content_type(Mime::XLS) }
    end

  end

  as_authenticated_only :post => :create, :report => 'an report' do
    before { @current_account.should_receive(:build_report).with('an report').and_return(mock_report) }

    describe 'with valid params' do
      before { mock_report.should_receive(:save).and_return(true) }
      it { should redirect_to(report_url(mock_report)) }
      it { should set_the_flash(:notice) }
    end

    describe 'with invalid params' do
      before { mock_report.should_receive(:save).and_return(false) }
      it { should respond_with(:success) }
      it { should render_template("new") }
    end
  end

  as_authenticated_only :put => :update, :id => '12', :report => 'an report' do
    before { @current_account.should_receive(:find_reports).with('12').and_return(mock_report) }
    
    describe 'with valid params' do
      before { mock_report.should_receive(:update_attributes).with('an report').and_return(true) }
      it { should redirect_to(report_url(mock_report)) }
      it { should set_the_flash(:notice) }
    end

    describe 'with invalid params' do
      before { mock_report.should_receive(:update_attributes).with('an report').and_return(false) }
      it { should respond_with(:success) }
      it { should render_template("edit") }
    end
  end

  as_authenticated_only :delete => :destroy, :id => '12' do
    before { @current_account.should_receive(:find_reports).with('12').and_return(mock_report(:name => 'Foo')) }
    before { mock_report.should_receive(:destroy) }

    it { should set_the_flash(:notice) }
    it { should redirect_to(reports_url) }
  end
end
