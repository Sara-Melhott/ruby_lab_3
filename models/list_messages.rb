# frozen_string_literal: true

require_relative 'message'
require 'date'

# Класс для работы со списком сообщений
class ListMessages
  extend Forwardable

  def initialize(list_messages)
    @list_messages = list_messages.map do |hash|
      Message.new(DateTime.iso8601(hash['timestamp']), hash['user_name'],
                  hash['text'])
    end
  end

  def list_messages
    @list_messages.dup
  end

  def add(message)
    @list_messages << message
  end

  def sort_messages
    @list_messages.sort do |message1, message2|
      message1.timestamp <=> message2.timestamp
    end
  end

  def timestamp_last_message
    if @list_messages.empty?
      DateTime.new(0, 1, 1, 0, 0, 0, '+00:00')
    else
      sort_messages[@list_messages.length - 1].timestamp
    end
  end

  def number_uniq_user_name
    @list_messages.map(&:user_name).uniq.length
  end

  def censored(word)
    @list_messages.reduce(0) do |sum, message|
      sum + message.censored(word)
    end
  end

  def to_hash
    @list_messages.map do |message|
      { 'timestamp' => message.timestamp.to_s, 'user_name' => message.user_name,
        'text' => message.text }
    end
  end
end
