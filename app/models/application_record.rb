class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  include Swagger::Blocks


  swagger_schema :BaseReturnPeriodModel do
    key :required, [:return_period]
    property :return_period  do
      key :type, :string
      key :message, 'RETURN PERIOD Ex. 052017'
    end
  end
  swagger_schema :BaseStateCodeModel do
    allOf do
      schema do
        key :'$ref', :BaseReturnPeriodModel
      end
      schema do
        property :state_code do
          key :type, :string
          key :message, 'State code Ex. 33'
        end
      end
    end
  end

  swagger_schema :UploadDocBase do
    property :ct do
      key :type, :string
      key :message, 'Content type'
    end
    property :doc do
      key :type, :string
      key :message, 'Doc data in Base64 format'
    end
    property :ty do
      key :type, :string
      key :message, 'Doc type code ex RETC'
    end
    property :doc_nam do 
      key :type, :string
      key :message, 'Document name'
    end
  end

  swagger_schema :BaseCertiModal do
    property :gstin do
      key :type, :string
    end
    property :fp do
      key :type, :string
    end
    property :isauditor do
      key :type, :string
    end
    property :cert_data do
      key :type, :object
    end
  end

  swagger_schema :CDNRInvoiceModel do
    allOf do
      schema do
        key :'$ref', :BaseActionRequiredModel
      end
      schema do
        property :from_time do
          key :type, :string
        end
      end
    end
  end

  swagger_schema :CDNRInvoiceModelWithActionRequired do
    allOf do
      schema do
        key :'$ref', :BaseActionRequiredModel
      end
      schema do
        property :action_required do
          key :type, :string
        end
      end
    end
  end


  swagger_schema :ReturnStatusModel do
    allOf do
      schema do
        key :'$ref', :BaseReturnPeriodModel
      end
      schema do
        key :required, [:return_period, :reference_id]
        property :reference_id  do
          key :type, :string
          key :message, 'reference_id got from save_invoices response'
        end
      end
    end
  end

  swagger_schema :FileDetailsModel do
    allOf do
      schema do
        key :'$ref', :BaseReturnPeriodModel
      end
      schema do
        key :required, [:return_period, :token]
        property :token do
          key :type, :string
          key :message, 'Ex. XYZABC'
        end
      end
    end
  end

  swagger_schema :BaseActionRequiredModel do
    allOf do
      schema do
        key :'$ref', :BaseReturnPeriodModel
      end
      schema do
        property :action_required do
          key :type, :string
        end
      end
    end
  end

  swagger_schema :BaseStateCodeModel do
    allOf do
      schema do
        key :'$ref', :BaseReturnPeriodModel
      end
      schema do
        property :state_code do
          key :type, :string
          key :message, 'State code Ex. 33'
        end
      end
    end
  end

  swagger_schema :ChecksumModel do
    key :required, [:checksum]
    property :checksum  do
      key :type, :string
      key :message, 'AflJufPlFStqKBZ'
    end
  end

  swagger_schema :AadhaarEsignRequest do
    allOf do
      schema do
        key :'$ref', :AadhaarOtpRequest
      end
      schema do
        key :required, [:aadhaar_otp, :patron_id]
        property :aadhaar_otp do
          key :type, :string
          key :message, 'OTP received from Aadhaar. Required for ESign.'
        end
        property :patron_id do
          key :type, :string
          key :message, 'Patron ID for Signzy, as sent in OTP response.'
        end
      end
    end
  end

  swagger_schema :DscRequest do
    key :required, [:pan_number, :signed_data]
    property :pan_number  do
      key :type, :string
      key :message, 'pan number'
    end
    property :signed_data  do
      key :type, :string
      key :message, 'PKCS#7 signature of SHA-256 hash of Base64 of Request payload JSON using private key of Tax Payer (Authorized signatory)'
    end
  end

  swagger_schema :GstrDataModel do
    allOf do
      schema do
        key :'$ref', :BaseReturnPeriodModel
      end
      schema do
        key :required, [:return_period, :data]
        property :data do
          key :type, :object
        end
      end
    end
  end

  swagger_schema :BaseFinancialPeriodModel do
    key :required, [:fp]
    property :fp  do
      key :type, :string
      key :message, 'Financial Period Ex. 052017'
    end
  end

  swagger_schema :Gstr9DataModel do
    allOf do
      schema do
        key :'$ref', :BaseFinancialPeriodModel
      end
      schema do
        key :required, [:fp, :data]
        property :data do
          key :type, :object
        end
      end
    end
  end

  swagger_schema :Gstr6SummaryModel do
    allOf do
      schema do
        key :'$ref', :BaseReturnPeriodModel
      end
      schema do
        key :required, [:return_period, :fnl]
        property :fnl do
          key :type, :string
          key :message, 'Final Attribute'
        end
      end
    end
  end

  swagger_schema :GstB2BInvoicesModel do
    allOf do
      schema do
        key :'$ref', :BaseReturnPeriodModel
      end
      schema do
        property :ctin do
          key :type, :string
        end
        property :from_time do
          key :type, :string
        end
        property :action_required do
          key :type, :string
        end
      end
    end
  end


  swagger_schema :GstB2BInvoicesModelWithoutFromTime do
    allOf do
      schema do
        key :'$ref', :BaseReturnPeriodModel
      end
      schema do
        property :ctin do
          key :type, :string
        end
        property :action_required do
          key :type, :string
        end
      end
    end
  end



  swagger_schema :CtinReturnPeriodModel do
    allOf do
      schema do
        key :'$ref', :BaseReturnPeriodModel
      end
      schema do
        property :ctin do
          key :type, :string
        end
      end
    end
  end
  swagger_schema :BaseGstinModel do
    key :required, [:gstin]
    property :gstins  do
      key :type, :array
      key :message, 'Ex. ["33GSPTN2931G1ZB", "33GSPTN2931G1ZB"] '
    end
  end

  swagger_schema :BasePanModel do
    key :required, :pan_number
    property :pan_number  do
      key :type, :string
      key :message, 'Ex. "33GSN29G1Z" '
    end
  end

  swagger_schema :BaseSingleGstinModel do
    key :required, :gstin
    property :gstin  do
      key :type, :string
      key :required, true
      key :message, 'Ex. "33GSPTN2931G1ZB" '
    end
  end

  swagger_schema :ViewAndTrackStatus do
    allOf do
      schema do
        key :'$ref', :BaseSingleGstinModel
      end
      schema do
        property :fy do
          key :type, :string
          key :required, true
          key :message, 'Ex. 072017 '
        end
        property :type do
          key :type, :string
          key :message, 'Ex. R1 '
        end
      end
    end
  end


  swagger_schema :OtpForEVC do
    allOf do
      schema do
        key :'$ref', :BaseSingleGstinModel
      end
      schema do
        property :pan do
          key :type, :string
          key :required, true
          key :message, 'Ex. HJKPS9689A8'
        end
        property :form_type do
          key :type, :string
          key :required, true
          key :message, 'Ex. R1 '
        end
      end
    end
  end

  swagger_schema :SessionDestroy do
    key :required, [:username, :auth_token, :password]
    property :username do
      key :type, :string
      key :required, true
      key :message, 'Ex. Sunny01'
    end
    property :auth_token do
      key :type, :string
      key :required, true
      key :message, 'Token got while authentication'
    end
    property :password do
      key :type, :string
      key :required, true
      key :message, 'password'
    end
  end
end