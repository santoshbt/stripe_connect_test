class Account
    def initialize(stripe_id)
        @stripe_id = stripe_id
    end

    def account_status
        Stripe.api_key = ENV['stripe_secret_key']
        Stripe::Account.retrieve(@stripe_id)
    end

    def fields_required 
        account_status.verification.fields_needed
    end

    def acceptance_status
        !account_status.tos_acceptance.date.blank? && !account_status.tos_acceptance.ip.blank?
    end

    def accept(request)        
        account_status.tos_acceptance.date = Time.now.to_i
        account_status.tos_acceptance.ip = request.remote_ip # Assumes you're not using a proxy
        account_status.save
    end

    def update_first_stage_info(req_params)
        account = account_status
        account.external_account = req_params[:external_account]
        account.legal_entity.dob.day = req_params[:day]
        account.legal_entity.dob.month = req_params[:month]
        account.legal_entity.dob.year = req_params[:year]
        account.legal_entity.first_name = req_params[:first_name]
        account.legal_entity.last_name = req_params[:last_name]
        account.legal_entity.type = req_params[:legal_entity_type]
        account.save
    end
        
end