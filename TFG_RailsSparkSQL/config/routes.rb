Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'epoches#index'
  get '/epoches/index', to: 'epoches#index'
  get '/pointns/loadCsv', to: 'pointns#loadCsv'
  get '/pointns/testDirectory', to: 'pointns#testDirectory'
  post '/epoches/map', to: 'epoches#map'
  get '/epoches/map_test', to: 'epoches#map_test'
  get '/epoches/dfs_test', to: 'epoches#dfs_test'
end
