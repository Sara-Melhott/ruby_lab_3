# frozen_string_literal: true

# Класс для работы с отдельным сообщением'
class Message
  attr_reader :user_name, :text, :timestamp

  def initialize(timestamp, user_name, text)
    @timestamp = timestamp.freeze
    @user_name = user_name.freeze
    @text = text.freeze
  end

  def censored(word)
    if @user_name.nil?
      count = @text.scan(word).length
    else
      count = (@user_name.scan(word) + @text.scan(word)).length
      @user_name = @user_name.gsub(word.to_s, '*')
    end
    @text = @text.gsub(word.to_s, '*')
    count
  end

  def to_s
    "Дата: #{@timestamp}; Имя: #{@user_name}; Текст: #{@text}"
  end
end
