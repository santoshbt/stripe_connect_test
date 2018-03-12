class HomeController < ApplicationController
    before_action :authenticate_user!
    after_action :update_account_status, except: ['index', 'complete']

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

    ############## Bank Details verificaiton ############################
    def bank_details_verification
        account = Account.new(current_user.stripe_id)
        if account.bank_detail_verification(current_user, params[:bank_detail] )
            @success_flag = true
        else
            @success_flag = false
        end
        respond_to do |format|
            format.js 
        end
    end

   ###############  Verify the additional required info ###################
    def first_stage_info
        stripe = StripeCustom.new(params[:user])        

        if stripe.met_verification
            account = Account.new(current_user.stripe_id)
            first_stage = account.update_first_stage_info( stripe ) 
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
        @proof = Proof.new
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

    def upload_id_proof
        @proof = Proof.new proof_params
        @proof.save    
        account = Account.new(current_user.stripe_id)        
        if account.upload_proof(@proof)            
            redirect_to complete_verfification_path
        else
            flash[:error] = "Please input the required information along with the valid ID Proof."
            render 'second_stage_info'
        end  
    end

    def complete
        account = Account.new(current_user.stripe_id)
        verification_status = account.account_status.legal_entity.verification.status  
        redirect_to root_path unless verification_status == "verified"
    end

    private
    def proof_params
        params.require(:proof).permit(:purpose, :file, :personal_id_number)
    end

    def update_account_status
        account = Account.new(current_user.stripe_id)
        verification_status = account.account_status.legal_entity.verification.status                
        current_user.update_attributes({status: verification_status})         
    end
end
