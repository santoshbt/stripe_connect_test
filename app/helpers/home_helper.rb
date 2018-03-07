module HomeHelper
    def stripe_account_created?
        current_user.stripe_id ? true  : false  
    end

    def stripe_account_display
        stripe_account_created? ? "display:none;" : "display:block;"            
    end

    def agreement_accepted? 
        current_user.stripe_id && @agreement_accepted ? true : false
    end
    
    def agreement_display
        agreement_accepted? ? "display:none;" : "display:block;"
    end

    def display_required_info
        agreement_accepted? ? "display:bolck" : "display:none;"
    end
end
