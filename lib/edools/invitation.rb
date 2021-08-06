# frozen_string_literal: true

module Edools
  class Invitation
    attr_reader :id, :first_name, :email, :errors, :data

    def initialize(data = {})
      @id = data[:id]
      @first_name = data[:first_name]
      @email = data[:email]
      @errors = data[:errors]
      @data = data
    end

    def enrollment_data
      {
        student_id: @data[:id],
        registration_id: @data[:registrations].pluck(:id),
        enrollment_id: @data[:enrollments].pluck(:id),
        school_product_id: @data[:enrollments].pluck(:school_product_id)
      }
    end

    def active_enrollment_by(school_product_id)
      @data[:enrollments].find do |e|
        e[:status] == 'active' && e[:school_product_id] == school_product_id
      end
    end

    def self.create(data = {})
      new Edools::ApiRequest.request(:post, base_url, invitation: data)
    rescue Edools::RequestWithErrors => exception
      new exception.errors
    end

    def self.base_url
      "#{Edools.base_url}/invitations"
    end
  end
end
