class CreateSovereignWealthFunds < ActiveRecord::Migration
  def self.up
    create_table :sovereign_wealth_funds do |t|
      t.column :country_name, :string
      t.column :fund_name, :string
      t.column :url_name, :string
      t.column :assest,:string
      t.column :inception,:string
      t.timestamps
    end
    SovereignWealthFund.reset_column_information
    lists=[["Algeria","Revenue Regulation Fund ","www.swfinstitute.org/fund/algeria.php","$47","2000"],
           ["Australia","Australian Future Fund","www.swfinstitute.org/fund/australia.php","$59.1","2004"],
           ["Azerbaijan","State Oil Fund","www.swfinstitute.org/fund/azerbaijan.php","$14.9","1999"],
           ["Bahrain" ,"Mumtalakat Holding Company","www.swfinstitute.org/fund/bahrain.php","$14","2006"],
           ["Botswana","Pula Fund","www.swfinstitute.org/fund/pula.php","$6.9" ,"1996"],
           ["Brazil","Sovereign Fund of Brazil","www.swfinstitute.org/fund/brazil.php","$8.6","2009"],
           ["Brunei", "Brunei Investment Agency","www.swfinstitute.org/fund/brunei.php" ,"$30","1983"],
           ["Canada", "Alberta's Heritage Fund" ,"www.swfinstitute.org/fund/alberta.php","$13.8","1976"],
           ["Chile","Social and Economic Stabilization Fund","www.swfinstitute.org/fund/chile.php","$21.8","1985"],
           ["China","SAFE Investment Company","www.swfinstitute.org/fund/safe.php", "$347.1**",""],
           ["China","China Investment Corporation","www.swfinstitute.org/fund/cic.php","$288.8","2007"],
           ["China","National Social Security Fund","www.swfinstitute.org/fund/nssf.php","$146.5","2000"],
           ["China","China-Africa Development Fund","www.swfinstitute.org/fund/cad.php","$5.0","2007"],
           ["China - Hong Kong","Hong Kong Monetary Authority Investment Portfolio","www.swfinstitute.org/fund/hongkong.php","$139.7","1993"],
           ["East Timor","Timor-Leste Petroleum Fund","www.swfinstitute.org/fund/etimor.php","$5.0","2005"],
           ["France","Strategic Investment Fund","www.swfinstitute.org/fund/france.php","$28","2008"],
           ["Indonesia" ,"Government Investment Unit","www.swfinstitute.org/fund/pip.php","$0.3","2006"],
           ["Iran","Oil Stabilisation Fund","www.swfinstitute.org/fund/iran.php","$23.0","1999"],
           ["Ireland","National Pensions Reserve Fund","www.swfinstitute.org/fund/ireland.php","$30.6","2001"],
           ["Kazakhstan","Kazakhstan National Fund","www.swfinstitute.org/fund/kazakhstan.php","$38","2000"],
           ["Kiribati","Revenue Equalization Reserve Fund","www.swfinstitute.org/fund/kiribati.php","$0.4","1956"],
           ["Kuwait","Kuwait Investment Authority","www.swfinstitute.org/fund/kuwait.php","$202.8","1953"],
           ["Libya", "Libyan Investment Authority","www.swfinstitute.org/fund/libya.php","$70","2006"],
           ["Malaysia","Khazanah Nasional","www.swfinstitute.org/fund/malaysia.php","$25","1993"],
           ["Mauritania","National Fund for Hydrocarbon Reserves","www.swfinstitute.org/fund/mauritania.php","$0.3","2006"],
           ["New Zealand", "New Zealand Superannuation Fund","www.swfinstitute.org/fund/newzealand.php","$11.4","2003"],
           ["Nigeria","Excess Crude Account","www.swfinstitute.org/fund/nigeria.php","$9.4","2004"],
           ["Norway","Government Pension Fund – Global","www.swfinstitute.org/fund/norway.php","$474","1990"],
           ["Oman","State General Reserve Fund","www.swfinstitute.org/fund/oman.php","$8.2","1980"],
           ["Oman","Oman Investment Fund", "www.swfinstitute.org/fund/oif.php",	"X", 	"2006"],
           ["Qatar","Qatar Investment Authority","www.swfinstitute.org/fund/qatar.php","$65","2005"],
           ["Russia","National Welfare Fund","www.swfinstitute.org/fund/russia.php", 	"$168.0*", 	"2008"],
           ["Saudi Arabia","SAMA Foreign Holdings","www.swfinstitute.org/fund/saudi.php","$432 ","n/a"],
           ["Saudi Arabia","Public Investment Fund","www.swfinstitute.org/fund/saudipif.php","$5.3","2008"],
           ["Singapore", "Government of Singapore Investment Corporation","www.swfinstitute.org/fund/gic.php","$247.5","1981"],
           ["Singapore","Temasek Holdings","www.swfinstitute.org/fund/temasek.php","$122","1974"],
           ["South Korea","Korea Investment Corporation","www.swfinstitute.org/fund/korea.php","$27","2005"],
           ["Trinidad & Tobago","Heritage and Stabilization Fund","www.swfinstitute.org/fund/tobago.php","$2.9","2000"],
           ["UAE - Abu Dhabi","Abu Dhabi Investment Authority","www.swfinstitute.org/fund/adia.php" ,"$627","1976"],
           ["UAE - Abu Dhabi","International Petroleum Investment Company","www.swfinstitute.org/fund/ipic.php","$14","1984"],
           ["UAE - Abu Dhabi","Abu Dhabi Investment Council","www.swfinstitute.org/fund/adic.php","X","2007"],
           ["UAE - Dubai","Investment Corporation of Dubai","www.swfinstitute.org/fund/dubai.php","$19.6","2006"],
           ["UAE - Abu Dhabi","Mubadala Development Company","www.swfinstitute.org/fund/mubadala.php","$13.3","2002"],
           ["UAE - Abu Dhabi","Abu Dhabi Investment Council","www.swfinstitute.org/fund/adic.php" ,"X" ,"2007"],
           ["UAE - Dubai","Investment Corporation of Dubai","www.swfinstitute.org/fund/dubai.php","$19.6","2006"],
           ["UAE - Federal","Emirates Investment Authority","www.swfinstitute.org/fund/uae.php","X","2007"],
           ["UAE - Ras Al Khaimah","RAK Investment Authority","www.swfinstitute.org/fund/rak.php","$1.2","2005"],
           ["US - Alaska","Alaska Permanent Fund","www.swfinstitute.org/fund/alaska.php","$35.5","1976"],
           ["US - New Mexico","New Mexico State Investment Office Trust","www.swfinstitute.org/fund/newmexico.php","$12.9","1958"],
           ["US - Wyoming","Permanent Wyoming Mineral Trust Fund","www.swfinstitute.org/fund/wyoming.php","$3.6","1974"],
           ["Venezuela","FEM","www.swfinstitute.org/fund/venezuela.php","$0.8","1998"],
           ["Vietnam","State Capital Investment Corporation","www.swfinstitute.org/fund/vietnam.php","$0.5" ,"2006"]
          ]
          lists.sort.each do |element|
      SovereignWealthFund.create(:country_name => element[0], :fund_name => element[1], :url_name => element[2],:assest => element[3],:inception =>element[4])
    end

  end

  def self.down
    drop_table :sovereign_wealth_funds
  end
end
