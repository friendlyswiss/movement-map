Rails.application.routes.draw do
  get 'imports/get_moves'

  get 'imports/unmarshall'

  get 'pages/home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
