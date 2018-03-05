class StripeCustom
    # mount_uploader :attachment, AttachmentUploader

    attr_reader :account_token, :first_name, :last_name, :day, :month, :year, :legal_entity_type

    def initialize(account_token, first_name, last_name, day, month, year, legal_entity_type)
        @account_token = account_token
        @first_name = first_name
        @last_name = last_name
        @day = day
        @month = month
        @year = year
        @legal_entity_type = legal_entity_type
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