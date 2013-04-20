Sloanconnect::Application.routes.draw do

  match 'connect'    => "users#edit",       :via => [:get] 
  match 'authorize'  => "linked_in#create", :via => [:post]
  match 'authorized' => "linked_in#show",   :via => [:get]
  match 'disconnect' => "users#destroy",    :via => [:delete]
  root  :to          => "users#new",        :via => [:get]

end
