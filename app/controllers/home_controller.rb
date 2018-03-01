class HomeController < ApplicationController
    before_action :authenticate_user!

    def index   
        ### Check if any additional fields are required
        # @additional_fields_required = Account.new(current_user.stripe_id).fields_required  unless current_user.stripe_id.blank?
        @additional_fields_required = ['yes']    
    end

    def info
        country = current_user.country || 'US'
        @success_flag = false
        if current_user.stripe_id.blank?
            begin
                stripe_account = current_user.create_stripe_account({ country: country, type: "custom" })
                current_user.update_attributes(stripe_id: stripe_account.id)
                @success_flag = true

                ###  Need to get the additional fields immediately after creating the account
                @additional_fields_required = Account.new(current_user.stripe_id).fields_required  unless current_user.stripe_id.blank?          
            rescue Exception => e
                @success_flag = false
            end               
        end
        respond_to do |format|
            format.js 
        end
    end

    def additional_fields

    end
end
