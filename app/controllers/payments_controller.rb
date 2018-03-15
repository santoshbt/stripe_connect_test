class PaymentsController < ApplicationController
    def list
        @verified_users = User.verified
    end

    def pay
        user_id = params[:id]
        @user = User.find user_id
    end

    def charge
        @user = User.find params[:id]        
        @credit = Payment.new(@user.stripe_id).pay(params[:payment], params["stripeToken"])
    end
end
