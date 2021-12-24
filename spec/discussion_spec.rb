# frozen_string_literal: true

require_relative '../models/discussion'
require_relative '../models/list_messages'
require_relative '../models/message'

RSpec.describe Discussion do
  def discussion
    Discussion.new(1, 'Котики', %w[коты котята], Date.new(2011, 11, 3),
                   hash)
  end

  def hash
    [{ 'timestamp' => '2021-10-28T21:20:44+00:00',
       'user_name' => 'Настя', 'text' => 'Привет!' },
     { 'timestamp' => '2021-09-28T21:20:44+00:00', 'user_name' => 'Маша',
       'text' => 'Привет!' },
     { 'timestamp' => '2021-09-28T21:20:44+00:00', 'user_name' => 'Маша',
       'text' => 'Привет!' }]
  end

  it 'should return true or false does the tag exist' do
    expect(discussion.tag?('коты')).to be true
    expect(discussion.tag?('пес')).to be false
  end
  it 'should return number censored' do
    expect(discussion.censored('т')).to eq(5)
    expect(discussion.censored('шок')).to eq(0)
  end
  it 'should return in text format' do
    expect(discussion.to_s).to eq(
      "Тема: Котики\nДата создания: 2011-11-03\nСписок тегов: "\
      "[\"коты\", \"котята\"]\n"
    )
  end
end
