class Payment
    def initialize(stripe_id)
        @stripe_id = stripe_id
    end

    def account_status
        Stripe.api_key = ENV['stripe_secret_key']        
    end
    
    def pay(payment, token)
        account_status
        amount_in_dollors = payment['amount'].to_i * 100
        begin
            charge = Stripe::Charge.create(
                :amount => amount_in_dollors,
                :currency => payment['currency'].downcase,
                :description => payment['description'],
                :source => token,
                :destination => @stripe_id 
            )
            puts charge.inspect
            puts charge.status.inspect
            return charge if charge.status == StripeCustom::SUCCESS
        rescue => exception
            return nil
        end
    end
end