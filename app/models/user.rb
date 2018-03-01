class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def create_stripe_account(params = {})  
    Stripe.api_key = ENV['stripe_secret_key']

    Stripe::Account.create({
        :country => params[:country],
        :type => params[:type]
    })    
  end   
end
