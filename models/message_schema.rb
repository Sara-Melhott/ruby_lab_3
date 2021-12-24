# frozen_string_literal: true

require 'dry-schema'
require_relative 'strip_string'

MessageSchema = Dry::Schema.Params do
  required(:user_name).maybe(StripStringSchema::StripString)
  required(:text).filled(StripStringSchema::StripString)
end
