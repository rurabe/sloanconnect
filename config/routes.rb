Sloanconnect::Application.routes.draw do

  match 'connect'   => "users#edit"
  match 'authorize' => "users#create"
  root  :to         => "users#new"

end
