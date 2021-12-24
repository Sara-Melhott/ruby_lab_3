# frozen_string_literal: true

require 'dry-schema'
require_relative 'strip_string'

CensoredSchema = Dry::Schema.Params do
  required(:word).filled(StripStringSchema::StripString)
end
