# frozen_string_literal: true

require 'tempfile'
require_relative '../models/list_discussions'

RSpec.describe ListDiscussions do
  let(:discussion_three) do
    Discussion.new(2, 'Попугаи', %w[птицы перья], Date.new(2011, 9, 3),
                   hash_list_messages)
  end

  let(:discussion_one) do
    Discussion.new(0, 'Котики', %w[коты шерсть], Date.new(2011, 11, 3),
                   hash_list_messages)
  end

  let(:discussion_two) do
    Discussion.new(1, 'Собаки', %w[собаки шерсть], Date.new(2011, 10, 3),
                   [])
  end

  let(:list_discussions) do
    ListDiscussions.new(array_discussions,
                        File.expand_path('spec/input_test.json'))
  end

  let(:new_list_discussions) do
    ListDiscussions.new([], File.expand_path('spec/input_test.json'))
  end

  def new_array_discussions
    [discussion_one, discussion_two, discussion_three, discussion_one]
  end

  def hash_tags
    { 0 => '', 1 => 'коты', 2 => 'шерсть', 3 => 'собаки', 4 => 'птицы',
      5 => 'перья' }
  end

  def sort_list_discussions(id)
    if id == 1
      [array_discussions[2], array_discussions[1], array_discussions[0]]
    else
      [array_discussions[1], array_discussions[0], array_discussions[2]]
    end
  end

  def sort_list_messages
    list = list_discussions.list_discussions[0].list_messages.list_messages
    [list[2], list[0], list[1]]
  end

  def array_discussions
    [discussion_one, discussion_two, discussion_three]
  end

  def hash_list_messages
    [{ 'timestamp' => '2021-10-28T21:20:44+00:00',
       'user_name' => 'Настя', 'text' => 'Привет!' },
     { 'timestamp' => '2021-11-28T21:20:44+00:00', 'user_name' => 'Маша',
       'text' => 'Привет!' },
     { 'timestamp' => '2021-09-28T21:20:44+00:00', 'user_name' => 'Маша',
       'text' => 'Привет!' }]
  end

  def hash_list_discussions
    [{ 'name' => 'Котики', 'list_tags' => %w[коты шерсть],
       'date_creation' => '2011-11-03',
       'list_messages' => hash_list_messages },
     { 'name' => 'Собаки', 'list_tags' => %w[собаки шерсть],
       'date_creation' => '2011-10-03',
       'list_messages' => [] },
     { 'name' => 'Попугаи', 'list_tags' => %w[птицы перья],
       'date_creation' => '2011-09-03',
       'list_messages' => hash_list_messages }]
  end

  it 'should return new discussions id' do
    expect(list_discussions.new_id).to eq(3)
  end

  it 'should return copy discussion' do
    copy = list_discussions.discussion(0)
    expect(copy.name).to eq(discussion_one.name)
    expect(copy.list_tags).to eq(discussion_one.list_tags)
    expect(copy.date_creation).to eq(discussion_one.date_creation)
    expect(copy.list_messages).to eq(discussion_one.list_messages)
  end

  it 'should add discussion from form in list discussions' do
    new_list_discussions.add_discussion_from_form('Жабы', '#жабки')
    expect(new_list_discussions.list_discussions[0].name).to eq('Жабы')
    expect(new_list_discussions.list_discussions[0].list_tags).to eq(['жабки'])
    expect(new_list_discussions.list_discussions[0].date_creation).to eq(
      Date.today
    )
    expect(new_list_discussions.list_discussions[0].list_messages
    .list_messages).to eq([])
  end

  it 'should return sort list discussions for params' do
    expect(list_discussions.sort_discussions('0', '-1')).to eq(
      array_discussions
    )
    expect(list_discussions.sort_discussions('0', 'sort_date')).to eq(
      sort_list_discussions(1)
    )
    expect(list_discussions.sort_discussions('0', 'sort_last_message')).to eq(
      sort_list_discussions(2)
    )
    expect(list_discussions.sort_discussions('0', 'sort_number_uniq_user_name'))
      .to eq(sort_list_discussions(2))
    expect(list_discussions.sort_discussions('2', '-1')).to eq(
      [array_discussions[0], array_discussions[1]]
    )
  end

  it 'should return hash tags' do
    expect(list_discussions.list_tags).to eq(hash_tags)
  end

  it 'read data json' do
    new_list_discussions.read_data_json(
      File.expand_path('spec/input_test_for_read.json')
    )
    expect(new_list_discussions.list_discussions[0].name).to eq('Котики')
    expect(new_list_discussions.list_discussions[0].list_tags).to eq(%w[коты
                                                                        шерсть])
    expect(new_list_discussions.list_discussions[0].date_creation).to eq(
      Date.new(2021, 10, 28)
    )
    expect(new_list_discussions.list_discussions[0].list_messages
    .list_messages[0].timestamp).to eq(DateTime.new(2021, 10, 28, 21, 20, 44,
                                                    '+00:00'))
    expect(new_list_discussions.list_discussions[0].list_messages
    .list_messages[0].user_name).to eq('Маша')
    expect(new_list_discussions.list_discussions[0].list_messages
    .list_messages[0].text).to eq('Эти зверьки очень милые)')
  end

  it 'write data json' do
    temp_file = Tempfile.new(['temp', '.json'], 'spec')
    list_discussions.write_data_json(File.expand_path(temp_file.path.to_s))
    expect(FileUtils.compare_file('spec/output_test.json',
                                  temp_file.path.to_s)).to be true
  end

  it 'should return hash' do
    expect(list_discussions.to_hash).to eq(hash_list_discussions)
  end

  it 'should return add new discussion' do
    list_discussions.add(discussion_one)
    expect(list_discussions.list_discussions).to eq(new_array_discussions)
  end

  it 'should return new list with new discussion' do
    new_list_discussions.create_discussion('Жабы', ['жабки'])
    expect(new_list_discussions.list_discussions[0].name).to eq('Жабы')
    expect(new_list_discussions.list_discussions[0].list_tags).to eq(['жабки'])
    expect(new_list_discussions.list_discussions[0].date_creation).to eq(
      Date.today
    )
    expect(new_list_discussions.list_discussions[0].list_messages
    .list_messages).to eq([])
  end

  it 'should return sort list to date creation' do
    expect(list_discussions
      .sort_discussions_date_creation(array_discussions)).to eq(
        sort_list_discussions(1)
      )
  end

  it 'should return sort list to timestamp last message' do
    expect(list_discussions
      .sort_discussions_timestamp_last_message(array_discussions)).to eq(
        sort_list_discussions(2)
      )
  end

  it 'should return sort list to number uniq user name' do
    expect(list_discussions
      .sort_discussions_number_uniq_user_name(array_discussions)).to eq(
        sort_list_discussions(3)
      )
  end

  it 'should return sort list message' do
    expect(list_discussions.sorted_messages(0)).to eq(sort_list_messages)
  end

  it 'should return list discussion with new message' do
    list_discussions.add_message(1, 'Даша', 'Hey!')
    expect(list_discussions.list_discussions[1]).to eq(array_discussions[1])
    expect(list_discussions.list_discussions[1]
    .list_messages.list_messages[0].user_name).to eq('Даша')
    expect(list_discussions.list_discussions[1]
    .list_messages.list_messages[0].text).to eq('Hey!')
  end

  it 'should return list with tag' do
    expect(list_discussions.find_discussion_by_tag('шерсть')).to eq(
      [array_discussions[0], array_discussions[1]]
    )
    expect(list_discussions.find_discussion_by_tag('жабы')).to eq([])
  end

  it 'should return number censored' do
    expect(list_discussions.censored('а')).to eq(12)
  end
end
