class StripeCustom
    attr_reader :account_token, :first_name, :last_name, :day, :month, :year, :legal_entity_type

    PENDING = "pending"
    VERIFIED = "verified"
    NEWONE = "newone"
    SUCCESS = "succeeded"

    ADDTIONAL_INFO = ["legal_entity.dob.day", "legal_entity.dob.month", "legal_entity.dob.year", 
                        "legal_entity.first_name", "legal_entity.last_name", "legal_entity.type"]

    def initialize(user)        
        @first_name = user['first_name']
        @last_name = user['last_name']
        @day = user['dob(3i)'].to_i
        @month = user['dob(2i)'].to_i
        @year = user['dob(1i)'].to_i
        @legal_entity_type = user['legal_entity_type']
    end

    def met_verification
        if (!@first_name.blank? && !@last_name.blank? && !@day.blank? \
            && !@month.blank? && !@year.blank? && !@legal_entity_type.blank?)
            return true
        else
            return false    
        end
    end
end