# frozen_string_literal: true

require 'dry-types'

# Необходим для преробразования строковых типов данных
# (убирает лишние пробелы)
module StripStringSchema
  include Dry.Types
  StripString = self::String.constructor(&:strip)
end
