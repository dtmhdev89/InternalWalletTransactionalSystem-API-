class Account < ApplicationRecord
  has_secure_password

  before_validation :downcase_email

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :type, presence: true

  has_many :active_sessions, dependent: :destroy

  class << self
    def authenticate_by(attributes)
      a_temp_record = new
      passwords, identifiers = attributes.to_h.partition do |name, value|
        !a_temp_record.has_attribute?(name) && a_temp_record.has_attribute?("#{name}_digest")
      end.map(&:to_h)

      raise ArgumentError, "One or more password arguments are required" if passwords.blank?
      raise ArgumentError, "One or more finder arguments are required" if identifiers.blank?

      record = identifiers_record(identifiers)
      return record if record && validate_passwords(record, passwords)

      new(passwords)
      nil
    end

    private

    def identifiers_record(identifiers)
      find_by(identifiers)
    end

    def validate_passwords(record, passwords)
      password_attr_name, password_value = passwords.to_a.flatten
      record.public_send(:"authenticate_#{password_attr_name}", password_value).present?
    end
  end

  private

  def downcase_email
    return if email.nil?

    email = self.email.downcase
  end
end
