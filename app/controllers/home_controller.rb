class HomeController < ApplicationController
    before_action :authenticate_user!

    def index  
        @agreement_accepted = false
        unless current_user.stripe_id.blank? 
            @agreement_accepted = Account.new(current_user.stripe_id).acceptance_status      
        end  
    end

    #### Need to refactor ####
    def agreement
        begin
            account_status = Account.new(current_user.stripe_id).account_status
            account_status.tos_acceptance.date = Time.now.to_i
            account_status.tos_acceptance.ip = request.remote_ip # Assumes you're not using a proxy
            account_status.save 
            @accept_flag = true
        rescue Exception => e
            @accept_flag = false
        end
        respond_to do |format|
            format.js 
        end
    end

    ############ Create (Initiate) Custom account   ################
    def info
        country = current_user.country || 'US'
        @success_flag = false
        if current_user.stripe_id.blank?
            begin
                stripe_account = current_user.create_stripe_account({ country: country, type: "custom" })
                current_user.update_attributes(stripe_id: stripe_account.id)
                @success_flag = true

                @agreement_accepted = Account.new(current_user.stripe_id).acceptance_status               
            rescue Exception => e
                @success_flag = false
            end               
        end
        respond_to do |format|
            format.js 
        end
    end

   ###############  Verify the additional required info ###################
    def first_stage_info
        user = params[:user]
        account_token = params[:account_token]
        first_name = params[:first_name]
        last_name = params[:last_name]
        day, month, year = user['dob(3i)'].to_i, user['dob(2i)'].to_i, user['dob(1i)'].to_i
        legal_entity_type = params[:legal_entity_type]

        stripe = StripeCustom.new(account_token, first_name, last_name, day, month, year, legal_entity_type)        

        if stripe.met_verification
            account = Account.new(current_user.stripe_id)
            first_stage = account.update_first_stage_info({
                                                        external_account: stripe.account_token,
                                                        first_name: stripe.first_name,
                                                        last_name: stripe.last_name,
                                                        day: stripe.day,
                                                        month: stripe.month,
                                                        year: stripe.year,
                                                        legal_entity_type: stripe.legal_entity_type
                                                        })

            redirect_to second_stage_info_path
        else 
            @agreement_accepted = true
            flash[:error] = "Please provide all the details"   
            render :index
        end    
    end

    def second_stage_info
        account = Account.new(current_user.stripe_id).account_status
        @type = 'company' if account.legal_entity.type  == 'company'
    end

    def location_info
        account = Account.new(current_user.stripe_id)        
        if account.update_location_info(params[:location])
            @success_flag = true
        else
            @success_flag = false
        end
        respond_to do |format|
            format.js 
        end
    end
end
