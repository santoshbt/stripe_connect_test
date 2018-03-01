class Account
    def initialize(stripe_id)
        @stripe_id = stripe_id
    end

    def fields_required
        Stripe.api_key = ENV['stripe_secret_key']
        account_status = Stripe::Account.retrieve(@stripe_id)
        account_status.verification.fields_needed
    end
        
end