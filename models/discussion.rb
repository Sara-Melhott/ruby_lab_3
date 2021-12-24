# frozen_string_literal: true

require_relative 'list_messages'

# Класс для работы с отдельным обсуждением
class Discussion
  attr_reader :id, :name, :list_tags, :date_creation, :list_messages

  def initialize(id, name, list_tags, date_creation, list_messages)
    @id = id.freeze
    @name = name.freeze
    @list_tags = list_tags.freeze
    @date_creation = date_creation.freeze
    @list_messages = ListMessages.new(list_messages)
  end

  def tag?(tag)
    @list_tags.index(tag) != nil
  end

  def date_last_message
    list_messages.timestamp_last_message
  end

  def number_uniq_user_name
    list_messages.number_uniq_user_name
  end

  def censored(word)
    count = @name.scan(word).length + list_messages.censored(word)
    @name = @name.gsub(word.to_s, '*')
    count
  end

  def to_s
    "Тема: #{@name}\nДата создания: #{@date_creation}\n" \
      "Список тегов: #{@list_tags}\n"
  end
end
