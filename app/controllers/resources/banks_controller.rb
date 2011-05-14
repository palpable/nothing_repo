class Resources::BanksController < ApplicationController
   before_filter :right_nav
  def index
    @central_banks =CentralbankList.find(:all,:order=> "country_name")
    @sovereign_wealth_fund=SovereignWealthFund.find(:all,:order =>"country_name")
    @links=CheckLink.find(:all,:order => "name")
    @supranational_sovereign = Person.find(:all, :conditions => {:business_type => 'Supranational and Sovereign issuers'}, :order => "name")
    @asset_manager = Person.find(:all, :conditions => {:business_type => 'Asset Managers'}, :order => "name")
    @hedge_funds = Person.find(:all, :conditions => {:business_type => 'Hedge Fund Manager'}, :order => "name")
    @banks_dealers = Person.find(:all, :conditions => {:business_type => 'Broker/Dealer'}, :order => "name")
                                        
    @other_issuers = Person.find(:all, :conditions => ["business_type=? OR business_type=?",'Other','Issuer'], :order => "name")
    @primary_dealers = Person.find(:all, :conditions => {:business_type => 'Primary Dealer'}, :order => "name")
    @regional_issuer = Person.find(:all, :conditions => {:business_type => 'Regional Issuer'}, :order => "name")
  end
  def central_bank
   
    if params[:choose] == "central_bank"
        
    @central_banks =CentralbankList.find(:all,:order=> "country_name")
     #render :update do |page|
     #page << "$('#view').addClass('active')"
     render :partial =>'central_banks'
     #end
    
    elsif params[:choose] == "wealthfunds"
     @sovereign_wealth_fund=SovereignWealthFund.find(:all,:order =>"country_name")
     render :partial => 'sovereign_wealth_fund'
    elsif params[:choose] == "sovereign"
    @supranational_sovereign = Person.find(:all, :conditions => {:business_type => 'Supranational and Sovereign issuers'}, :order => "name")
    render :partial => 'supranational_sovereign'
    elsif params[:choose] == "asset"
    @asset_manager = Person.find(:all, :conditions => {:business_type => 'Asset Managers'}, :order => "name")
   render :partial => 'asset_managers'
   elsif params[:choose] == "hedge"
   @hedge_funds = Person.find(:all, :conditions => {:business_type => 'Hedge Fund Manager'}, :order => "name")
    
   render :partial => 'hedge_funds'
    elsif params[:choose] == "bankdealers"
   @banks_dealers = Person.find(:all, :conditions => {:business_type => 'Broker/Dealer'}, :order => "name")
   render :partial => 'banks_dealers'
    elsif params[:choose] == "otherissuer"
     @other_issuers = Person.find(:all, :conditions => ["business_type=? OR business_type=?",'Other','Issuer'], :order => "name")
    render :partial => 'other_issuers'
     elsif params[:choose] == "links"
     @links=CheckLink.find(:all,:order => "name")
      render :partial => 'links'
    elsif params[:choose] == "news"
      render :partial =>'news'
    end
    #return
  end
  
  def profile_display
    @person=Person.find(params[:id])
    render :layout =>false
  end
  def edit_bank 
    @central_bank = CentralbankList.find(params[:id])  
  end
  
  def update_bank
     @central_bank = CentralbankList.find(params[:id])  
     
       if @central_bank.update_attributes(params[:central_bank])
         redirect_to :action=>'show_bank',:id=>@central_bank.id
       else
         render :action =>'edit_bank'
       end
  end
  
  def show_bank
     @central_bank = CentralbankList.find(params[:id])  
 end
 
 def new_bank
   @central_bank = CentralbankList.new
 end
 
 def create_bank
    @central_bank = CentralbankList.new(params[:centralbank])
    if @central_bank.save
        redirect_to :action=>'show_bank',:id=>@central_bank.id
      else
        render :action =>'new_bank'
    end
 end
 
 def delete_bank
    @central_bank = CentralbankList.find(params[:id])  
    @central_bank.destroy
    redirect_to :action=>'index'
 end
 def new_fund
   @fund=SovereignWealthFund.new
 end
 
 def create_fund
   @fund = SovereignWealthFund.new(params[:fund])
    if @fund.save
       flash[:notice]="Sovereign Wealth Fund successfully updated"
        redirect_to :action=>'index'
      else
        render :action =>'new_fund'
    end
 end
 
 def edit_fund
     @fund = SovereignWealthFund.find(params[:id])
 end
 def update_fund
    @fund = SovereignWealthFund.find(params[:id])

       if @fund.update_attributes(params[:fund])
       flash[:notice]="Sovereign Wealth Fund successfully updated"
         redirect_to :action=>'index'
       else
         render :action =>'edit_fund'
       end
 end
 def delete_fund
    @fund = SovereignWealthFund.find(params[:id])
    @fund.destroy
    redirect_to :action=>'index'
 end
  
end
