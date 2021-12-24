# frozen_string_literal: true

require_relative '../models/list_messages'

RSpec.describe ListMessages do
  let(:list_messages) do
    ListMessages.new(hash)
  end

  let(:empty_list_message) do
    ListMessages.new([])
  end

  let(:new_message) do
    Message.new(DateTime.new(2021, 10, 28, 21, 20, 44, '+00:00'), 'Даша',
                'Пока!')
  end

  def hash
    [{ 'timestamp' => '2021-10-28T21:20:44+00:00',
       'user_name' => 'Настя', 'text' => 'Привет!' },
     { 'timestamp' => '2021-11-28T21:20:44+00:00', 'user_name' => 'Маша',
       'text' => 'Привет!' },
     { 'timestamp' => '2021-09-28T21:20:44+00:00', 'user_name' => 'Маша',
       'text' => 'Привет!' }]
  end

  def other_list_messages
    list_messages.list_messages
  end

  def sort_list_messages
    [list_messages.list_messages[2], list_messages.list_messages[0],
     list_messages.list_messages[1]]
  end

  it 'should return copy list' do
    expect(list_messages.list_messages).to eq(other_list_messages)
  end

  it 'should add new message in list' do
    list_messages.add(new_message)
    other_list_messages << new_message
    expect(list_messages.list_messages).to eq(other_list_messages)
  end

  it 'should return sort list' do
    expect(list_messages.sort_messages).to eq(sort_list_messages)
  end

  it 'should return timestamp' do
    expect(list_messages.timestamp_last_message).to eq(
      DateTime.new(2021, 11, 28, 21, 20, 44, '+00:00')
    )
    expect(empty_list_message.timestamp_last_message).to eq(
      DateTime.new(0, 1, 1, 0, 0, 0, '+00:00')
    )
  end

  it 'should return number uniq user name in list message' do
    expect(list_messages.number_uniq_user_name).to eq(2)
  end

  it 'should return number censored' do
    expect(list_messages.censored('Маша')).to eq(2)
    expect(list_messages.censored('Привет!')).to eq(3)
  end

  it 'should return hash' do
    expect(list_messages.to_hash).to eq(hash)
  end
end
