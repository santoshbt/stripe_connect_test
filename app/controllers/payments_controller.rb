class PaymentsController < ApplicationController
    def list
        @verified_users = User.verified
    end

    def pay
        user_id = params[:id]
        @user = User.find user_id
    end

    def charge
        user = User.find params[:id]
        puts user.inspect
        
        debit = Payment.new(user.stripe_id).pay(params[:payment])
        # if account.upload_proof(@proof)            
        #     redirect_to complete_verfification_path
        # else
        #     flash[:error] = "Please input the required information along with the valid ID Proof."
        #     render 'second_stage_info'
        # end
    end
end
