require 'prome/web'

Rails.application.routes.draw do
  resources :asps
  mount Prome::Web, at: "/metrics"
  mount PgHero::Engine, at: "pghero"

  resources :contacts
  resources :feedbacks

  devise_for :users, path: 'dashboard/users', controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }
  get 'gstn1_api', to: 'gstr1#index'
  get 'save_invoices', to: 'gstr1#save_invoices'
  get 'file_gstr1', to: 'gstr1#file_gstr1'
  get 'submit_gstr1', to: 'gstr1#submit_gstr1'
  get 'users', to: 'gstr1#users'


  post 'api/aadhaar_esign_otp_request', to: 'api/gstn_base#aadhaar_esign_otp_request'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: "homepage#index"

  #smileandfile
  get '/smile_and_file', to: redirect('http://www.smileandfile.com')
  
  # T&C type stuff
  get '/terms_conditions', to: 'homepage#terms_conditions'
  get '/privacy_policies', to: 'homepage#privacy_policies'
  get '/legal_policies', to: 'homepage#legal_policies'
  get '/accessability', to: 'homepage#accessability'
  get '/faq', to: 'homepage#faq'
  get '/whats_new', to: 'homepage#whats_new'

  # OTP Related stuff
  get 'otp/authenticate', to: "otp#authenticate"
  post 'otp/validate', to: "otp#validate"
  post 'otp/generate', to: "otp#generate"
  get 'validate_user', to: "otp#validate_user"

  %w( 404 422 500 ).each do |code|
    get code, :to => "errors#show", :code => code
  end

  namespace :dashboard do
    get '/', to: 'dashboard#index'

    get '/new_user_domain', to: 'dashboard#new_user_domain'
    post '/create_user_domain', to: 'dashboard#create_user_domain'

    get '/api_tester', to: 'dashboard#api_tester'

    get '/audit', to: 'audit#index'
    get '/audit/common_api', to: 'audit#common_api'
    get '/audit/eway_api', to: 'audit#eway_api'
    get '/file_downloads', to: 'file_download#index'

    get '/search_taxpayer', to: 'public_apis#search_taxpayer'
    get '/account_details', to: 'domains#account_details'
    
    resources :branches

    resources :gstn_base, only: [:none] do
      collection do
        get :set_gstin
        post :save_current_session_gstin
      end
    end
    resources :dsc, only: [:none] do
      collection do
        get :register
        get :sign
      end
    end
    resources :snf_settings do
      collection do
        get :reset_token
        post :update_gstin_token_nil
        post :update_eway_token_nil
        post :update_common_token_nil
      end
    end
    resources :roles
    resources :gstr3b do
      collection do
        post :save_gstr3b_excel
        get :import_excel
        post :save_gstr3b
        get :request_otp
        get :details
        get :submit
        get :offset_liability
        get :track_status
      end
    end
    resources :transactions, only: [:none] do
      collection do
        get :topup_ccav_request_handler
        post :topup_ccav_response_handler
        post :topup_cancel_url
      end
    end
    resources :orders do
      member do
        get :make_payment
        get :online_payment_if_gateway_failure
      end
      resources :transactions, only: [:none] do
        collection do
          get :ccav_request_handler
          post :ccav_response_handler
          post :cancel_url
        end
      end

    end
    resources :packages do
      collection do
        get :purchase
      end
    end
    resources :gstins
    resources :entities do
      member do
        get :gstins
      end
    end
    resources :domains do
      collection do
        get :create_access_request_new
        post :create_access_request_admin
        get :special_domain_creation
        post :special_domain
        post :purchase_gstins
      end
      resources :working_level, only: [:none] do
        collection do
          post :set
          get :level
        end
      end
      resources :users do
        collection do
          get :permissions
        end
      end
    end

  end

  namespace :api do
    mount_devise_token_auth_for 'User', at: 'users', skip: [:validatable], controllers: {
      passwords:          'api/users/passwords',
      registrations:      'api/users/registrations',
      sessions:           'api/users/sessions',
    }
    resources :gstn_auth, only: [:none] do
      collection do
        post :confirm_otp
        post :request_otp
        post :refresh_auth_token
        post :evc_otp
      end
    end

    resources :ewaybills, only: [:none] do
      collection do
        post :authenticate
        get :eway_bill
        get :eway_bill_transporter
        get :eway_bils_transporter_by_gstin
        get :eway_bils_generated_by_others
        get :gstin_detail
        get :transporter_detail
        get :error_list
        get :cons_eway_bills
        get :hsn_code_detail
        post :generate_eway_bill
        post :update_transporter
        post :extend_validity
        post :regenerate_consolidated_eway_bill
        post :update_vehicle_number
        post :cancel_eway_bill
        post :reject_eway_bill
        post :generate_consolidated_eway_bill
        post :multi_vehicle_movement_initiation
        post :multi_vehicle_add
        post :multi_vehicle_update
        get :eway_bill_generated_by_consigner
        get :eway_bill_for_transporter_by_state
        get :ewaybill_by_date
        get :ewaybill_rejected_by_others
      end
    end
    resources :roles
    resources :branches
    resources :gstins
    resources :entities do
      resources :gstins
    end

    resources :docs
    resources :packages do
      member do
        get :purchase
      end
    end

    post "/public_apis/search_taxpayer_v1.2", to: "public_apis#search_taxpayer_new_version"
    resources :public_apis, only: [:none] do
      collection do
        post :common_authenticate
        post :search_taxpayer
        post :view_and_track_status
        post :session_destroy
        post :search_by_pan
      end
    end
    resources :gstn_all, only: [:none] do
      collection do
        post :load_files
        get :all_files
        get '/file/:id', to: 'gstn_all#file'
        post :view_track_return_status
        post :upload_doc
        get :download_doc
        get :doc_status
        get :late_fee
        post :proceed_to_file
      end
    end

    resources :file_downloads

    resources :dsc, only: [:none] do
      collection do
        post :register
        post :deregister
      end
    end
    resources :gstn1, only: [:none] do
      collection do
        post :save_invoices
        post :submit_gstr1
        post :file_gstr1_esign
        post :file_gstr1_dsc
        post :gstr1_summary
        post :return_status
        post :b2b_invoices
        post :b2cl_invoices
        post :b2cs_invoices
        post :cdnr_invoices
        post :nil_rated
        post :exp
        post :hsn_summary
        post :at
        post :txp
        post :txpa
        post :cdnur_invoices
        post :doc_issued
        post :file_details
        post :b2ba_invoices
        post :b2cla_invoices
        post :b2csa_invoices
        post :cdnra_invoices
        post :expa
        post :ata
        post :cdnura_invoices
      end
    end
    resources :gstr1a, only: [:none] do
      collection do
        post :file_gstr1_esign
        post :file_gstr1_dsc
        post :gstr1a_summary
        post :b2b_invoices
        post :cdnr_invoices
        post :b2ba_invoices
        post :cdnra_invoices
        post :save_invoices
        post :submit_gstr1a
      end
    end

    resources :gstn2a, only: [:none] do
      collection do
        post :b2b_invoices
        post :cdn_invoices
        post :isd_credit
      end
    end
    resources :gstr3b, only: [:none] do
      collection do
        post :offset_liability
        post :save_gstr3b
        post :submit_gstr3b
        post :gstr3b_details
        post :track_status
        post :file_gstr3b_dsc
      end
    end
    resources :gstr2, only: [:none] do
      collection do
        post :b2b_invoices
        post :import_goods_invoices
        post :import_service_bills
        post :cdn_invoices
        post :nil_rated
        post :tax_liability_reverse_charge_summary
        post :tax_paid_reverse_charge
        post :gstr2_summary
        post :save_invoices
        post :b2bur
        post :cdnur
        post :submit_gstr2
        post :itc_rvsl
        post :hsn
        post :file_gstr2_dsc
        post :file_gstr2_esign
      end
    end
    resources :gstr3, only: [:none] do
      collection do
        post :gstr3_details
        post :save_gstr3
        post :generate_gstr3
        post :file_gstr3_esign
        post :file_gstr3_dsc
        post :submit_liabilities_and_interest
        post :setoff_liability
        post :submit_refund
        post :return_status
      end
    end
    resources :gstr4, only: [:none] do
      collection do
        post :save_invoices
        post :b2b_invoices
        post :b2b_unregistered_invoice
        post :import_of_services
        post :cdn_invoices
        post :cdnr_invoices
        post :cdnur
        post :tax_on_outward_supplies
        post :advances_paid
        post :advances_adjusted
        post :summary
        post :submit
        post :tds
        post :file_esign
        post :file_dsc
        post :set_off_liability
        post :b2b_invoices_amendment
        post :b2b_unregistered_invoice_amendment
        post :credit_note_invoice_amendment
        post :credit_note_unregistered_invoice_amendment
        post :import_of_services_amendment
        post :advances_paid_amendment
        post :advances_adjusted_amendment
      end
    end

    resources :gstr6, only: [:none] do
      collection do
        post :save_invoices
        post :cdn_invoices
        post :b2b_invoices
        post :isd_details
        post :summary
        post :submit
        post :file_dsc
        post :file_esign
        post :late_fee
        post :itc_details
        post :mismatch_details
        post :refund_claim
        post :submit_refund_claim
        post :offset_late_fee
      end
    end

    resources :gstr9, only: [:none] do
      collection do 
        post :file_details
        post :file_dsc
        post :calculate_details
        post :save_data
      end
    end

    resources :gstr9a, only: [:none] do
      collection do
        post :file_details
        post :file_dsc
        post :calculate_details
        post :save_data
      end
    end

    resources :gstr9c, only: [:none] do
      collection do
        post :generate_certi
        post :summary
        post :file_gstr9c
        post :gstr9_records
        post :save_gstr9c
        post :hash_generator
      end
    end

    resources :ledger, only: [:none] do
      collection do
        post :cash_ledger
        post :itc_ledger
        post :liability_ledger_return_liability
        post :retliab_balance
        post :cash_itc_balance
      end
    end
    resources :domains do
      collection do
        post :create_access_request_admin
      end
      resources :users
      resources :entities
    end
  end
end
