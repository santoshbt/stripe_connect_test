class StripeCustom
    attr_reader :account_token, :first_name, :last_name, :day, :month, :year, :legal_entity_type

    def initialize(user)
        @account_token = user['account_token']
        @first_name = user['first_name']
        @last_name = user['last_name']
        @day = user['dob(3i)'].to_i
        @month = user['dob(2i)'].to_i
        @year = user['dob(1i)'].to_i
        @legal_entity_type = user['legal_entity_type']
    end

    def met_verification
        if (!@account_token.blank? && !@first_name.blank? && !@last_name.blank? && !@day.blank? \
            && !@month.blank? && !@year.blank? && !@legal_entity_type.blank?)

            return true
        else
            return false    
        end
    end
end