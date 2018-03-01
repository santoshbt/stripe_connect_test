class HomeController < ApplicationController
    before_action :authenticate_user!

    def index
        
    end

    def info
        country = current_user.country || 'US'

        stripe_account = current_user.create_stripe_account({country: country, type: "custom"})
        puts stripe_account.inspect
    end
end
