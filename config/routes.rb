ActionController::Routing::Routes.draw do |map|
 

  map.resources :cb_forums,:collection =>{}
#map.connect 'road_shows/message',:controller=>'road_shows',:action=>'road_show_message'
  map.connect 'road_shows/partialrenderer',:controller=>'road_shows',:action=>'partialrenderer'
   map.connect 'rooms/partialrenderer',:controller=>'rooms',:action=>'partialrenderer'
 map.connect 'people/change_photo',:controller=>'people',:action=>'change_photo'
  map.connect 'road_shows/youtubeurl_add',:controller=>'road_shows',:action=>'youtubeurl_add'
   map.connect 'rooms/youtubeurl_add',:controller=>'rooms',:action=>'youtubeurl_add'
  map.connect 'iphone/login', :controller => "iphone", :action => "login", :method=>:post
  map.resources :road_shows
  map.resources :forums,:collection => { }
 
 # map.resources :rooms
  map.resources :road_shows, :collection => { :road_show_message => :get,:search_sort_by => :get}
  map.resources :rooms,:collection => {:room_show_message => :get,:search_sort_by => :get }
  map.resources :docattachmentsvalue
  map.resources :infos,:collection => {:terms_of_use => :any,:privacy_policy => :any,:contact_us => :any,:help => :any}
  map.connect 'people/people_by_country',:controller=>'people',:action=>'people_by_country'
  map.connect 'people/choose_news_feed',:controller=>'people',:action=>'choose_news_feed'
  map.connect 'people/non_central_bank_sign_up',:controller=>'people',:action=>'non_central_bank_sign_up'
    map.connect 'people/central_bank_sign_up',:controller=>'people',:action=>'central_bank_sign_up'
  map.connect 'messages/search_sort_by',:controller=>'messages',:action=>'search_sort_by'
  map.root :controller => 'home'
  map.resources :categories
  map.resources :links
 
  map.resources :events, :member => { :attend => :get, 
                                      :unattend => :get } do |event|
    event.resources :comments
  end
  

  map.resources :preferences
  map.resources :searches
  map.resources :activities
  map.resources :connections
  map.resources :password_reminders
  map.resources :photos,
                :member => { :set_primary => :put, :set_avatar => :put }
  map.open_id_complete 'session', :controller => "sessions",
                                  :action => "create",
                                  :requirements => { :method => :get }
  map.resource :session
  map.resource :galleries
  map.resources :messages, :collection => { :sent => :get, :trash => :get, :new_message => :get },
                           :member => { :reply => :get, :undestroy => :put }

  map.resources :people, :member => { :verify_email => :get,
                                      :common_contacts => :get }
  map.connect 'people/verify/:id', :controller => 'people',
                                   :action => 'verify_email'
  map.resources :people do |person|
     person.resources :messages
     person.resources :galleries
     person.resources :connections
     person.resources :comments
  end
  
  map.resources :galleries do |gallery|
    gallery.resources :photos
  end
  map.namespace :admin do |admin|
  
    admin.resources :people,:controller =>'people',:collection =>{:delete_person => :any}
    admin.resources :preferences,:pendings
    admin.resources :news_feeds
    admin.resources :forums do |forums|
      forums.resources :topics do |topic|
        topic.resources :posts
      end
    end
     admin.resources :cb_forums do |forums|
      forums.resources :cb_topics do |topic|
        topic.resources :cb_posts
      end
    end
    admin.namespace :resources do |res|
      res.resources :banks, :controller => 'banks'
       res.resources :banks, :controller => 'banks',:collection => { :central_bank => :any }
      res.resources :issuers, :controller => 'issuers'
      res.resources :asset_managers, :controller => 'asset_managers'
      res.resources :hedge_funds, :controller => 'hedge_funds'
      res.resources :banks_dealers, :controller => 'banks_dealers'
    end
    
  end
  map.resources :blogs do |blog|
    blog.resources :posts do |post|
        post.resources :comments
    end
  end
  map.resources :blogs do |blog|
    blog.resources :cb_posts do |post|
        post.resources :comments
    end
  end

  map.resources :forums do |forums|
    forums.resources :topics do |topic|
      topic.resources :posts
    end
  end

     map.resources :cb_forums do |forums|
    forums.resources :cb_topics do |topic|
      topic.resources :cb_posts
    end
  end
  
  map.namespace :resources do |res|
    res.resources :banks, :controller => 'banks',:collection => { :central_bank => :any,:funds =>:any,:sovereign =>:any,:asset =>:any,:hedge_funds => :any,:banks_dealers =>:any,:other_issuers =>:any,:links =>:any}
  
    res.resources :issuers, :controller => 'issuers'
    res.resources :asset_managers, :controller => 'asset_managers'
    res.resources :hedge_funds, :controller => 'hedge_funds'
    res.resources :banks_dealers, :controller => 'banks_dealers'
  end
  
  map.signup_selection '/signup-selection', :controller => 'people', :action => 'select'
  map.signup '/signup', :controller => 'people', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.home '/', :controller => 'home'
 
  map.about '/about', :controller => 'home', :action => 'about'
  map.admin_home '/admin/home', :controller => 'home'

  map.root :controller => 'home'
  
  map.add_bank '/resources/add_bank' ,:controller =>'resources/banks',:action=>'new_bank'
  map.add_fund '/resources/add_fund',:controller =>'resources/banks',:action=>'new_fund'
  
   map.add_link '/resources/add_link' ,:controller =>'resources/banks',:action=>'new_link'
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
#  map.root :controller => "landing"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
