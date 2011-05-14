class CreateCentralbankLists < ActiveRecord::Migration
  def self.up
    create_table :centralbank_lists do |t|
      t.column :country_name, :string
      t.column :bank_name, :string
      t.column :url_name, :string
      t.timestamps
    end
    CentralbankList.reset_column_information
    lists= [["Afghanistan","Bank of Afghanistan","www.centralbank.gov.af"], ["Albania","Bank of Albania","www.bankofalbania.org"], ["Algeria", "Bank of Algeria" , "www.bank-of-algeria.dz"], ["Argentina" ,"Central Bank of Argentina","www.bcra.gov.ar"],["Armenia", "Central Bank of Armenia","www.cba.am"], ["Aruba","Central Bank of Aruba","www.cbaruba.org"],["Australia" ,"Reserve Bank of Australia","www.rba.gov.au"],["Austria" ,"Austrian National Bank","www.oenb.at"],["Azerbaijan","Central Bank of Azerbaijan Republic","www.nba.az"], ["Bahamas","Central Bank of The Bahamas","www.centralbankbahamas.com/index.lasso"],["Bahrain", "Central Bank of Bahrain","www.bma.gov.bh"], ["Bangladesh", "Bangladesh Bank","www.bangladesh-bank.org"],["Barbados","Central Bank of Barbados","www.centralbank.org.bb"], ["Belarus", "National Bank of the Republic of Belarus","www.nbrb.by/engl/"],["Belgium","National Bank of Belgium","www.bnb.be"], ["Belize" ,"Central Bank of Belize","www.centralbank.org.bz"],["Benin", "Central Bank of West African States (BCEAO)","www.bceao.int"], ["Bermuda","Bermuda Monetary Authority","www.bma.bm"],["Bhutan","Royal Monetary Authority of Bhutan","www.rma.org.bt"], ["Bolivia","Central Bank of Bolivia","www.bcb.gov.bo"],["Bosnia" ,"Central Bank of Bosnia and Herzegovina","www.cbbh.ba"], ["Botswana","Bank of Botswana","www.bankofbotswana.bw"],["Brazil" ,"Central Bank of Brazil","www.bcb.gov.br"], ["Bulgaria","Bulgarian National Bank","www.bnb.bg"],["Burkina Faso" ,"Central Bank of West African States (BCEAO)","www.bceao.int"], ["Burundi","Bank of the Republic of Burundi","www.brb-bi.net"],["Cambodia","National	Bank of Cambodia","www.nbc.org.kh"], ["Cameroon" , "Bank of Central African States","www.beac.int"],["Canada","Bank of Canada","www.bankofcanada.ca/en/"], ["Cayman Islands", "Cayman	Islands Monetary Authority","www.cimoney.com.ky"],["Central African Republic", "Bank of Central	African States","www.beac.int"], ["Chad","Bank of Central African States","www.beac.int"],["Chile","Central Bank of Chile","www.bcentral.cl"], ["China", "The People's Bank of China","www.pbc.gov.cn/english"],["Colombia" ,"Bank of the Republic","www.banrep.gov.co"], ["Comoros" ,"Central Bank of Comoros","www.bancecom.com"],["Congo", "Bank of Central African States","www.beac.int"], ["Costa Rica" ,"Central Bank of Costa Rica","www.bccr.fi.cr"],["Côte d'Ivoire" ,"Central Bank of West African States (BCEAO)","www.bceao.int"], ["Croatia","Croatian National Bank","www.hnb.hr"],["Cuba", "Central Bank of Cuba","www.bc.gov.cu/English/home.asp"], ["Cyprus" ,"Central Bank of Cyprus","www.centralbank.gov.cy"],["Czech Republic","Czech National Bank","www.cnb.cz"], ["Denmark","National	Bank of Denmark","www.nationalbanken.dk/dnuk/specialdocuments.nsf"],["Dominican Republic","Central Bank of the Dominican Republic","www.bancentral.gov.do"], ["East Caribbean area" , "Eastern 	Caribbean Central Bank","www.eccb-centralbank.org"],["Ecuador","Central Bank	of Ecuador","www.bce.fin.ec"], ["Egypt" ,"Central Bank of Egypt","www.cbe.org.eg/"],["El Salvador", "Central Reserve Bank of El Salvador","www.bcr.gob.sv"], ["Equatorial Guinea" , "Bank of Central African States","www.beac.int"],["Estonia","Bank of Estonia","www.bankofestonia.info"], ["Ethiopia","National Bank of Ethiopia","www.nbe.gov.et"],["European Union" ,"European Central Bank","www.ecb.int"], ["Fiji","Reserve Bank of Fiji","www.reservebank.gov.fj"],["Finland", "Bank of Finland","www.bof.fi"], ["France","Bank of France","www.banque-france.fr"],["Gabon","Bank of Central African States","www.beac.int"], ["The Gambia","Central Bank of The Gambia","www.cbg.gm"],
            ["Georgia","National Bank of Georgia","www.nbg.gov.ge"],["Germany","Deutsche Bundesbank","www.bundesbank.de"],["Ghana","Bank of Ghana","www.bog.gov.gh"],["Greece", "Bank of Greece","www.bankofgreece.gr"],["Guatemala" ,"Bank of Guatemala","www.banguat.gob.gt"], ["Guinea Bissau","Central Bank of West African States (BCEAO)","www.bceao.int"],["Guyana" , "Bank of Guyana","www.bankofguyana.org.gy"],["Haiti","Central Bank of Haiti","www.brh.net/"],["Honduras", "Central Bank of Honduras","www.bch.hn/"],["Hong Kong","Hong Kong Monetary Authority","www.info.gov.hk/hkma"],["Hungary","Magyar Nemzeti Bank","www.mnb.hu"],["Iceland","Central Bank of Iceland","www.sedlabanki.is"],["India","Reserve Bank of India","www.rbi.org.in"],["Indonesia","Bank Indonesia","www.bi.go.id"],["Iran","The Central Bank of the Islamic Republic of Iran","www.cbi.ir/default_en.aspx"],["Iraq","Central Bank of Iraq","www.cbi.iq"],["Ireland","Central Bank and Financial Services Authority of Ireland","www.centralbank.ie"],["Israel","Bank of Israel","www.bankisrael.gov.il"],["Italy","Bank of Italy","www.bancaditalia.it"],["Jamaica","Bank of Jamaica","www.boj.org.jm"],["Japan","Bank of Japan","www.boj.or.jp/en/index.htm"],["Jordan","Central Bank of Jordan","www.cbj.gov.jo"],["Kazakhstan","National Bank of Kazakhstan","www.nationalbank.kz"],["Kenya","Central Bank of Kenya","www.centralbank.go.ke"],["Korea","Bank of Korea","eng.bok.or.kr"],["Kuwait","Central Bank of Kuwait","www.cbk.gov.kw"],["Kyrgyzstan","National Bank of the Kyrgyz Republic","www.nbkr.kg"],["Latvia","Bank of Latvia","www.bank.lv"],["Lebanon","Central Bank of Lebanon","www.bdl.gov.lb"],["Lesotho","Central Bank of Lesotho","www.centralbank.org.ls"],["Libya","Central Bank of Libya","www.cbl.gov.ly/en/"],["Lithuania","Bank of Lithuania","www.lbank.lt"],["Luxembourg","Central Bank of Luxembourg","www.bcl.lu"],
 ["Macao" ,"Monetary Authority of Macao","www.amcm.gov.mo"],
["Macedonia,FYR", "NationalBank of the Republic of Macedonia","www.nbrm.gov.mk"],
["Madagascar" , "Central Bank of Madagascar","www.banque-centrale.mg"],
["Malawi" ,"Reserve Bank of Malawi","www.rbm.mw"],
["Malaysia" ,"CentralBank of Malaysia","www.bnm.gov.my"],
["Mali" ,"Central Bank of West African States (BCEAO)","www.bceao.int"],
["Malta" ,"CentralBank of Malta","www.centralbankmalta.org"],
["Mauritius" , "Bank of Mauritius","www.bom.intnet.mu"],
["Mexico","Bank of Mexico","www.banxico.org.mx"],
["Moldova","National Bank of Moldova","www.bnm.org"],
["Mongolia" , "Bank of Mongolia","www.mongolbank.mn"],
["Montenegro","Central Bank of Montenegro","www.cb-mn.org/eng/"],
["Mozambique","Bank of Mozambique","www.bancomoc.mz"],
["Namibia" ,"Bank of Namibia","www.bon.com.na"],
["Nepal","Central Bank of Nepal","www.nrb.org.np"],
["Netherlands", "Netherlands Bank","www.dnb.nl"],
["Netherlands Antilles","Bank of the Netherlands Antilles","www.centralbank.an"],
["New Zealand","Reserve Bank of New Zealand","www.rbnz.govt.nz"],
["Nicaragua" ,"Central Bank of Nicaragua","www.bcn.gob.ni"],
["Niger","Central Bank of West African States (BCEAO)","www.bceao.int"],
["Nigeria","Central Bank of Nigeria","www.cenbank.org"],
["Norway" ,"Central Bank of Norway","www.norges-bank.no"],
["Oman", "Central Bank of Oman","www.cbo-oman.org"],
["Pakistan","State Bank of Pakistan","www.sbp.org.pk"],
["Papua New Guinea" ,"Bank of Papua New Guinea","www.bankpng.gov.pg"],
["Paraguay" , "Central Bank of Paraguay","www.bcp.gov.py"],
["Peru","Central Reserve Bank of Peru","www.bcrp.gob.pe"],
["Philippines" ,"Bangko Sentral ng Pilipinas","www.bsp.gov.ph"],
["Poland" ,"National Bank of Poland","www.nbp.pl"],
["Portugal", "Bank of Portugal","www.bportugal.pt"],
["Qatar","Qatar Central Bank","www.qcb.gov.qa"],
["Romania","National Bank of Romania","www.bnro.ro"],
["Russia","Central Bank of Russia","www.cbr.ru/eng/"],
["Rwanda","National Bank of Rwanda","www.bnr.rw"],
["San Marino" ,"Central Bank of the Republic of San Marino","www.bcsm.sm"],
["Samoa" ,"Central Bank of Samoa","www.cbs.gov.ws"],
["Saudi Arabia","Saudi Arabian Monetary Agency","www.sama-ksa.org"],
["Senegal" ,"Central Bank of West African States (BCEAO)","www.bceao.int"],
["Serbia" ,"National Bank of Serbia","www.nbs.yu"],
["Seychelles", "Central Bank of Seychelles","www.cbs.sc"],
["Sierra Leone","Bank of Sierra Leone","www.bankofsierraleone-centralbank.org"],
["Singapore","Monetary Authority of Singapore","www.mas.gov.sg"],
["Slovakia" ,"National Bank of  Slovakia","www.nbs.sk"],
["Slovenia", "Bank of Slovenia","www.bsi.si"],
["Solomon Islands","Central Bank of Solomon Islands","www.cbsi.com.sb"],
["South Africa","South African Reserve Bank","www.resbank.co.za"],
["Spain", "Bank of Spain","www.bde.es"],
["SriLanka","Central Bank of Sri Lanka","www.cbsl.gov.lk"],
["Sudan","Bank of Sudan","www.bankofsudan.org"],
["Surinam" ,"Central Bank of Suriname","www.cbvs.sr"],
["Swaziland","The Central Bank of Swaziland","www.centralbank.org.sz"],
["Sweden" ,"Sveriges Riksbank","www.riksbank.com"],
["Switzerland", "Swiss National Bank","www.snb.ch"],
["Tajikistan" ,"National Bank of Tajikistan","www.nbt.tj/en/"],
["Tanzania" ,"Bank of Tanzania","www.bot-tz.org"],
["Thailand","Bank of Thailand","www.bot.or.th"],
["Togo" ,"Central Bank of West African States (BCEAO)","www.bceao.int"],
["Tonga","National Reserve Bank of Tonga","www.reservebank.to"],
["Trinidad and Tobago","Central Bank of Trinidad and Tobago","www.central-bank.org.tt"],
["Tunisia" ,"Central Bank of Tunisia","www.bct.gov.tn"],
["Turkey","Central Bank of the Republic of Turkey","www.tcmb.gov.tr"],
["Uganda" ,"Bank of Uganda","www.bou.or.ug"],
["Ukraine" ,"National Bank of Ukraine","www.bank.gov.ua"],
["United Arab Emirates" ,"Central Bank of United Arab Emirates","www.cbuae.gov.ae"],
["United Kingdom","Bank of England","www.bankofengland.co.uk"],
["United States" ,"Board of Governors of the Federal Reserve System (Washington)","www.federalreserve.gov"],
["United States", "Federal Reserve Bank of New York","www.newyorkfed.org"],
["Uruguay" ,"Central Bank of Uruguay","www.bcu.gub.uy"],
["Vanuatu","Reserve Bank of Vanuatu","www.rbv.gov.vu"],["Venezuela", "Central Bank of Venezuela","www.bcv.org.ve"],["Vietnam","The State Bank of Vietnam","www.sbv.gov.vn/en/home/"],["Yemen","Central Bank of Yemen","www.centralbank.gov.ye"],["Zambia","Bank of Zambia","www.boz.zm"],["Zimbabwe","Reserve Bank of Zimbabwe","www.rbz.co.zw"]]
     lists.sort.each do |element|
      CentralbankList .create(:country_name => element[0], :bank_name => element[1], :url_name => element[2])
    end
  end

  def self.down
    drop_table :centralbank_lists
  end
end
