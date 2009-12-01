require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdvertisersController do
  mock_models :advertiser

  as_authenticated_only :get => :index do
    before { @current_account.should_receive(:find_advertisers).with(:all).and_return([mock_advertiser]) }
    it { should respond_with(:success) }
  end

  as_authenticated_only :get => :new do
    before { @current_account.should_receive(:build_advertiser).and_return(mock_advertiser) }
    it { should respond_with(:success) }
  end
  
  as_authenticated_only :get => :edit, :id => '12' do
    before { @current_account.should_receive(:find_advertisers).with('12').and_return(mock_advertiser) }
    it { should respond_with(:success) }
  end
  
  as_authenticated_only :get => :show, :id => '12' do
    before do
      @current_account.should_receive(:find_advertisers).with('12').and_return(mock_advertiser)
      mock_advertiser.should_receive(:metrics_by_category).and_return('METRICS')
    end
    
    it { should respond_with(:success) }
    it { should assign_to(:categories, :with => 'METRICS')}
  end
  
  as_authenticated_only :post => :create, :advertiser => 'an advertiser' do
    before { @current_account.should_receive(:build_advertiser).with('an advertiser').and_return(mock_advertiser) }
    
    describe 'with valid params' do
      before { mock_advertiser.should_receive(:save).and_return(true) }
      it { should redirect_to(advertiser_url(mock_advertiser)) }
      it { should set_the_flash(:notice) }
    end

    describe 'with invalid params' do
      before { mock_advertiser.should_receive(:save).and_return(false) }
      it { should respond_with(:success) }
      it { should render_template("new") }
    end
  end

  as_authenticated_only :put => :update, :id => '12', :advertiser => 'an advertiser' do
    before { @current_account.should_receive(:find_advertisers).with('12').and_return(mock_advertiser) }
    
    describe 'with valid params' do
      before { mock_advertiser.should_receive(:update_attributes).with('an advertiser').and_return(true) }
      it { should redirect_to(advertiser_url(mock_advertiser)) }
      it { should set_the_flash(:notice) }
    end

    describe 'with invalid params' do
      before { mock_advertiser.should_receive(:update_attributes).with('an advertiser').and_return(false) }
      it { should respond_with(:success) }
      it { should render_template("edit") }
    end
  end

  as_authenticated_only :delete => :destroy, :id => '12' do
    before { @current_account.should_receive(:find_advertisers).with('12').and_return(mock_advertiser(:name => 'Foo')) }
    before { mock_advertiser.should_receive(:destroy) }

    it { should set_the_flash(:notice) }
    it { should redirect_to(advertisers_url) }
  end
end
