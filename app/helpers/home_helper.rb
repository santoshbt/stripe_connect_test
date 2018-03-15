module HomeHelper
    def stripe_account_created?
        current_user.stripe_id ? true  : false  
    end

    def stripe_account_display
        stripe_account_created? ? "display:none;" : "display:block;"            
    end

    def agreement_already_accepted?
        @agreement_accepted ? true : false
    end

    def agreement_yet_to_be_accepted?    
        !current_user.stripe_id.blank? && !@agreement_accepted ? true : false
    end
    
    def agreement_display
        agreement_yet_to_be_accepted? ? "display:block;" : "display:none;"
    end

    def display_required_info
        stripe_account_created? && @agreement_accepted ? "display:block" : "display:none;"
    end

    def account_buttons_display   
        (!stripe_account_created? || agreement_yet_to_be_accepted?) ? "display:block;" : "display:none;"
    end

    def active(controller, action)
        return "active" if current_controller == controller && current_action == action 
        return nil
    end

    def additional_details_verified?
        return true if !current_user.stripe_id.blank? && @account_status.verification.fields_needed - StripeCustom::ADDTIONAL_INFO == []
        return false
    end

    def bank_detail_verified?
        return true if !current_user.stripe_id.blank? && (!@account_status.verification.fields_needed.include?("external_account"))
        return false
    end

    def misc_details_verified?x
        return true  if !current_user.stripe_id.blank? && (@account_status.verification.fields_needed - ["external_account"]).blank?
        return false
    end
end
