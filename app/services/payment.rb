class Payment
    def initialize(stripe_id)
        @stripe_id = stripe_id
    end

    def account_status
        Stripe.api_key = ENV['stripe_secret_key']        
    end
    
    def pay(payment)
        account_status
        Stripe::Charge.create(
            :amount => payment['amount'],
            :currency => payment['currency'],
            :source => {
                :object => "card",
                :number => payment['number'],
                :exp_month => payment['exp_month'],
                :exp_year => payment['exp_year']
            },
            :destination => @stripe_id
        )

        puts Stripe::Account.retrieve(@stripe_id)
    end
end