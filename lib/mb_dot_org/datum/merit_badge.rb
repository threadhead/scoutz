module MbDotOrg
  module Datum
    class MeritBadge < MbDotOrg::Datum::Base
      def initialize(options={})
        @attributes = [
          :inspected,
          :name,
          :mb_org_url,
          :mb_org_worksheet_pdf_url,
          :mb_org_worksheet_doc_url,
          :discontinued,
          :bsa_advancement_id,
          :patch_image_url,
          :eagle_required,
          :year_created
        ]
        create_setters_getters_instance_variables(options)
      end


      def to_params
        to_params_without(:inspected)
      end
    end

  end
end
