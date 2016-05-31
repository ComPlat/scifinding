Rails.application.routes.draw do
  mount Scifinding::Engine => 'scifi'
end

Scifinding::Engine.routes.draw do
  root to: 'application#redirect_to_home'
  
  controller :home do
    get '/home/index' => :index
    post 'home/resource_51' => :resource_51
    post 'home/resource_52' => :resource_52
    post 'home/resource_53' => :resource_53
    post 'home/resource_61' => :resource_61
    post 'home/resource_62' => :resource_62
    post 'home/resource_63' => :resource_63
    post 'home/resource_71' => :resource_71
    post 'home/resource_72' => :resource_72
  end

end
