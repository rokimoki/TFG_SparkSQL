Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: '/epoches/index', to: 'epoches#index'
  get '/epoches/index', to: 'epoches#index'
  post '/epoches/map', to: 'epoches#map'
  post '/speeds/insert', to: 'speeds#insert'
  post '/points/insert', to: 'points#insert'
end
