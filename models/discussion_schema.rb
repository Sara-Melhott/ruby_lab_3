# frozen_string_literal: true

require 'dry-schema'
require_relative 'strip_string'

DiscussionSchema = Dry::Schema.Params do
  required(:name).filled(StripStringSchema::StripString)
  required(:list_tags).filled(StripStringSchema::StripString,
                              format?: /^(#[a-zA-ZА-Яа-я_]+)+$/)
end
