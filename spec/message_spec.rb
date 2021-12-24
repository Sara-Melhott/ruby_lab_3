# frozen_string_literal: true

require_relative '../models/message'

RSpec.describe Message do
  let(:message_one) do
    Message.new('2021-10-28T21:20:44+00:00', 'Настя', 'Привет!')
  end
  let(:message_two) do
    Message.new('2021-10-28T21:20:44+00:00', nil, 'Привет!')
  end

  it 'should return the number of substitutions censored' do
    expect(message_one.censored('Настя')).to eq(1)
    expect(message_one.censored('Даша')).to eq(0)
    expect(message_two.censored('Привет!')).to eq(1)
  end

  it 'should return in text format' do
    expect(message_one.to_s).to eq(
      'Дата: 2021-10-28T21:20:44+00:00; Имя: Настя; Текст: Привет!'
    )
  end
end
