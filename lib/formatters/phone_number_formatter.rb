module Formatters
  class PhoneNumberFormatter
    attr_reader :phone_number

    COUNTRY_CODE = :ae

    def initialize(phone_number)
      @phone_number = phone_number
    end

    def perform
      return '' if phone_number.blank?

      TelephoneNumber.parse(normalize_phone_number, COUNTRY_CODE).e164_number
    end

    private

    def normalize_phone_number
      normalized_phone_number = phone_number.tr('٠١٢٣٤٥٦٧٨٩','0123456789')
      normalized_phone_number = normalized_phone_number.gsub(/[\s]/, '').gsub(/^0+/, '+')

      normalized_phone_number
    end
  end
end
