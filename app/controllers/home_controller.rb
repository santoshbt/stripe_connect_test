class HomeController < ApplicationController
    before_action :authenticate_user!

    def index        
    end

    def info
        country = current_user.country || 'US'
        @success_flag = false
        if current_user.stripe_id.blank?
            begin
                stripe_account = current_user.create_stripe_account({country: country, type: "custom"})
                current_user.update_attributes(stripe_id: stripe_account.id)
                @success_flag = true             
            rescue Exception => e
                @success_flag = false
            end               
        end
        respond_to do |format|
            format.js 
        end
    end
end
