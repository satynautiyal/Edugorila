Rails.application.routes.draw do
  resources :file_upload_questions
  resources :results
  resources :questions
  get 'select_quiz_type', to: 'questions#select_quiz_type'
  get 'quiz_questions',to: 'questions#quiz_questions'
  resources :quizzes
  resources :subjects
  post 'upload_question', to: 'questions#upload_question'

  # resources :profiles
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'dashboards#show'
  devise_for :admins, controllers: { omniauth_callbacks: 'admins/omniauth_callbacks' }
  devise_scope :admin do
    get 'admins/sign_in', to: 'admins/sessions#new', as: :new_admin_session
    get 'admins/sign_out', to: 'admins/sessions#destroy', as: :destroy_admin_session
    post 'sign_up_with_credentials',to: 'admins/sessions#sign_up_with_credentials'
    post 'sign_in_with_credentials', to: 'admins/sessions#sign_in_with_credentials'
    post 'register', to: 'admins/sessions#register'
  end


  post 'test_result',to: 'questions#test_result'
  post 'upload_question',to: 'questions#upload_question'
  post '/profiles/:id', to: 'profiles#update'
  resources :profiles

  
end
