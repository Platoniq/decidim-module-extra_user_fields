# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module ExtraUserFields
    # Extra user fields definitions for forms
    module FormsDefinitions
      extend ActiveSupport::Concern

      included do
        include ::Decidim::ExtraUserFields::ApplicationHelper

        DNI_REGEX = /^(\d{8})([A-Z])$/
        NIE_REGEX = /^[XYZ]\d{7,8}[A-Z]$/

        # Block ExtraUserFields Attributes

        attribute :country, String
        attribute :postal_code, String
        attribute :date_of_birth, Decidim::Attributes::LocalizedDate
        attribute :gender, String
        attribute :phone_number, String
        attribute :location, String
        attribute :profession, String
        attribute :document_id, String

        # EndBlock

        # Block ExtraUserFields Validations

        validates :country, presence: true, if: :country?
        validates :postal_code, presence: true, if: :postal_code?
        validates :date_of_birth, presence: true, if: :date_of_birth?
        validates :gender, presence: true, inclusion: { in: Decidim::ExtraUserFields::Engine::DEFAULT_GENDER_OPTIONS.map(&:to_s) }, if: :gender?
        validates :phone_number, presence: true, if: :phone_number?
        validates :location, presence: true, if: :location?
        validates :profession, presence: true, if: :profession?
        validates :document_id, presence: true, if: :document_id?

        # EndBlock

        validate :check_document_id
      end

      def map_model(model)
        extended_data = model.extended_data.with_indifferent_access

        self.country = extended_data[:country]
        self.postal_code = extended_data[:postal_code]
        self.date_of_birth = Date.parse(extended_data[:date_of_birth]) if extended_data[:date_of_birth].present?
        self.gender = extended_data[:gender]
        self.phone_number = extended_data[:phone_number]
        self.location = extended_data[:location]
        self.profession = extended_data[:profession]
        self.document_id = extended_data[:document_id]

        # Block ExtraUserFields MapModel

        # EndBlock
      end

      private

      # Block ExtraUserFields EnableFieldMethod
      def country?
        extra_user_fields_enabled && current_organization.activated_extra_field?(:country)
      end

      def date_of_birth?
        extra_user_fields_enabled && current_organization.activated_extra_field?(:date_of_birth)
      end

      def gender?
        extra_user_fields_enabled && current_organization.activated_extra_field?(:gender)
      end

      def postal_code?
        extra_user_fields_enabled && current_organization.activated_extra_field?(:postal_code)
      end

      def phone_number?
        extra_user_fields_enabled && current_organization.activated_extra_field?(:phone_number)
      end

      def location?
        extra_user_fields_enabled && current_organization.activated_extra_field?(:location)
      end

      def profession?
        extra_user_fields_enabled && current_organization.activated_extra_field?(:profession)
      end

      def document_id?
        extra_user_fields_enabled && current_organization.activated_extra_field?(:document_id)
      end

      # EndBlock

      def check_document_id
        return unless document_id?

        case document_type
        when "DNI"
          errors.add(:document_id, :invalid) unless valid_dni?(document_id)
        when "NIE"
          errors.add(:document_id, :invalid) unless valid_nie?
        else
          errors.add(:document_id, :invalid)
        end
      end

      def document_type
        @document_type ||= if document_id =~ DNI_REGEX
                             "DNI"
                           elsif document_id =~ NIE_REGEX
                             "NIE"
                           end
      end

      def valid_nie?
        nie_prefix = case document_id[0]
                     when "X"
                       0
                     when "Y"
                       1
                     else
                       2
                     end
        valid_dni?("#{nie_prefix}#{document_id[1..]}")
      end

      def valid_dni?(dni)
        dni[-1] == "TRWAGMYFPDXBNJZSQVHLCKE"[dni.to_i % 23]
      end

      def extra_user_fields_enabled
        @extra_user_fields_enabled ||= current_organization.extra_user_fields_enabled?
      end
    end
  end
end
