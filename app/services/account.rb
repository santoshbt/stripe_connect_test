class Account
    def initialize(stripe_id)
        @stripe_id = stripe_id
    end

    def account_status
        Stripe.api_key = ENV['stripe_secret_key']
        Stripe::Account.retrieve(@stripe_id)
    end

    def fields_required 
        account_status.verification.fields_needed
    end

    def acceptance_status
        !account_status.tos_acceptance.date.blank? && !account_status.tos_acceptance.ip.blank?
    end

    ######## This method is not used as it is not working for unknown reason #######
    def accept(request)        
        account_status.tos_acceptance.date = Time.now.to_i
        account_status.tos_acceptance.ip = request.remote_ip # Assumes you're not using a proxy
        account_status.save
    end

    def update_first_stage_info(stripe_account)     
        account = account_status
        account.tap { |acc|
            acc.external_account = stripe_account.account_token
            acc.legal_entity.dob.day = stripe_account.day
            acc.legal_entity.dob.month = stripe_account.month
            acc.legal_entity.dob.year = stripe_account.year
            acc.legal_entity.first_name = stripe_account.first_name
            acc.legal_entity.last_name = stripe_account.last_name
            acc.legal_entity.type = stripe_account.legal_entity_type
            acc.save
        }       
    end

    def update_location_info(location)
        account = account_status
        begin
            account.tap { |acc|
                acc.legal_entity.address.line1 = location[:addr_line1]
                acc.legal_entity.address.postal_code = location[:postal_code]
                acc.legal_entity.address.city = location[:city]
                acc.legal_entity.address.state = location[:state]
                acc.legal_entity.ssn_last_4 = location[:ssn]
                acc.legal_entity.business_name = location[:business_name] unless location[:business_name].blank?
                # acc.legal_entity.business_tax_id unless location[:business_tax_id].blank?            
                return true if acc.save            
            }
        rescue => exception
            return false
        end
    end

    def upload_proof(proof)
        begin
            fpath = File.join Rails.root, 'public'
            file_obj = Stripe::FileUpload.create(
            {
                :purpose => proof.purpose,
                :file => File.new(fpath.to_s + proof.file.to_s)
            },
            {
                :stripe_account => @stripe_id
            }
            )
            file = file_obj.id

            account = account_status        
            account.tap { |acc|
                acc.legal_entity.personal_id_number = proof.personal_id_number
                acc.legal_entity.verification.document = file
                return true if acc.save
            }
        rescue => exception
            return false
        end
    end
        
end