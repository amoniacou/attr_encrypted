# frozen_string_literal: true

require 'simplecov'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter
  ]
)

SimpleCov.start do
  add_filter 'test'
end

require 'minitest/autorun'

require 'active_record'
require 'digest/sha2'
ActiveSupport::Deprecation.behavior = :raise

require 'attr_encrypted'

SECRET_KEY = SecureRandom.random_bytes(32)

def base64_encoding_regex
  /^(?:[A-Za-z0-9+\/]{4})*(?:[A-Za-z0-9+\/]{2}==|[A-Za-z0-9+\/]{3}=|[A-Za-z0-9+\/]{4})$/
end

def drop_all_tables
  connection = ActiveRecord::Base.connection
  connection.data_sources.each { |table| ActiveRecord::Base.connection.drop_table(table) }
end
