# frozen_string_literal: true

module Decidim
  module ExtraUserFields
    module Admin
      class ExtraUserFieldsForm < Decidim::Form
        include TranslatableAttributes

        attribute :enabled, Boolean
        attribute :country, Boolean
        attribute :postal_code, Boolean
        attribute :date_of_birth, Boolean
        attribute :gender, Boolean
        attribute :phone_number, Boolean
        attribute :location, Boolean
        attribute :profession, Boolean
        attribute :document_id_name, Boolean
        attribute :document_id, Boolean
        # Block ExtraUserFields Attributes

        # EndBlock

        def map_model(model)
          self.enabled = model.extra_user_fields["enabled"]
          self.country = model.extra_user_fields.dig("country", "enabled")
          self.postal_code = model.extra_user_fields.dig("postal_code", "enabled")
          self.date_of_birth = model.extra_user_fields.dig("date_of_birth", "enabled")
          self.gender = model.extra_user_fields.dig("gender", "enabled")
          self.phone_number = model.extra_user_fields.dig("phone_number", "enabled")
          self.location = model.extra_user_fields.dig("location", "enabled")
          self.profession = model.extra_user_fields.dig("profession", "enabled")
          self.document_id_name = model.extra_user_fields.dig("document_id_name", "enabled")
          self.document_id = model.extra_user_fields.dig("document_id", "enabled")
          # Block ExtraUserFields MapModel

          # EndBlock
        end
      end
    end
  end
end
