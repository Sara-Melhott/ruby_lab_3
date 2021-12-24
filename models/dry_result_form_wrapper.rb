# frozen_string_literal: true

require 'delegate'
require 'forme'

# Этот класс оборачивает результат
# DryRB для использования с forme
class DryResultFormeWrapper < SimpleDelegator
  def initialize(parameters)
    super(parameters)
    @parameters = parameters
    @errors = parameters.errors
  end

  def forme_input(form, field, opts)
    new_opts = opts.dup
    new_opts[:value] = @parameters[field]
    new_opts[:name] = field
    if @parameters.error?(field)
      new_opts[:error] =
        @errors[field].join(', ').capitalize
    end

    type = new_opts.delete(:type)
    if %i[checkbox radio].include?(type)
      value = new_opts.delete(:value)
      new_opts[:checked] = value
    end
    form._input(type, **new_opts)
  end
end
