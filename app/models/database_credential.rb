class DatabaseCredential < ApplicationRecord
  def password
    encryptor.decrypt_and_verify(super)
  end

  def password=(plain_data)
    encrypted_data = encryptor.encrypt_and_sign(plain_data)
    super(encrypted_data)
  end

  private

  def encryptor
    ActiveSupport::MessageEncryptor.new(key)
  end

  def key
    password = Rails.application.secrets[:secret_key_base]
    length = ActiveSupport::MessageEncryptor.key_len
    create_salt_if_needed
    ActiveSupport::KeyGenerator.new(password).generate_key(salt, length)
  end

  def create_salt_if_needed
    return unless salt.nil?

    length = ActiveSupport::MessageEncryptor.key_len
    self.salt = SecureRandom.hex(length)
  end
end
