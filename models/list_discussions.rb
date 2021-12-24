# frozen_string_literal: true

require_relative 'discussion'
require_relative 'list_messages'
require_relative 'message'
require 'json'
require 'date'

# Класс для работы со списком обсуждений
class ListDiscussions
  attr_reader :list_discussions

  def initialize(list_discussions, path)
    @list_discussions = list_discussions
    @path = path.freeze
  end

  def to_hash
    @list_discussions.map do |discussion|
      { 'name' => discussion.name, 'list_tags' => discussion.list_tags,
        'date_creation' => discussion.date_creation.to_s,
        'list_messages' => discussion.list_messages.to_hash }
    end
  end

  def new_id
    @list_discussions.size
  end

  def discussion(id)
    @list_discussions[id].dup
  end

  def read_data_json(path)
    return if File.zero?(path)

    json_data = File.read(path)
    ruby_objects = JSON.parse(json_data)
    ruby_objects.each do |hash|
      discussion = Discussion.new(new_id, hash['name'],
                                  hash['list_tags'],
                                  Date.iso8601(hash['date_creation']),
                                  hash['list_messages'])
      add(discussion)
    end
  end

  def write_data_json(path)
    File.open(path, 'w') do |file|
      file.write(JSON.pretty_generate(to_hash))
    end
  end

  def add(discussion)
    @list_discussions << discussion
  end

  def add_discussion_from_form(name, string_tags)
    list_tags = string_tags.split('#').delete_if { |tag| tag == '' }
    create_discussion(name, list_tags)
  end

  def create_discussion(name, list_tags)
    add(Discussion.new(new_id, name, list_tags, Date.today, []))
  end

  def sort_discussions(tag, filter)
    list = if tag == '0' || !tag
             @list_discussions
           else
             find_discussion_by_tag(list_tags[tag.to_i])
           end
    case filter
    when 'sort_date'
      sort_discussions_date_creation(list)
    when 'sort_last_message'
      sort_discussions_timestamp_last_message(list)
    when 'sort_number_uniq_user_name'
      sort_discussions_number_uniq_user_name(list)
    else
      list
    end
  end

  def sort_discussions_date_creation(list)
    list.sort do |discussion1, discussion2|
      discussion1.date_creation <=> discussion2.date_creation
    end
  end

  def sort_discussions_timestamp_last_message(list)
    list.sort do |discussion1, discussion2|
      discussion1.date_last_message <=> discussion2.date_last_message
    end
  end

  def sort_discussions_number_uniq_user_name(list)
    list.sort do |discussion1, discussion2|
      discussion1.number_uniq_user_name <=> discussion2.number_uniq_user_name
    end
  end

  def sorted_messages(number_discussion)
    @list_discussions[number_discussion].list_messages.sort_messages
  end

  def add_message(number_discussion, user_name, text)
    @list_discussions[number_discussion].list_messages
                                        .add(Message.new(DateTime.now,
                                                         user_name, text))
  end

  def list_tags
    list = @list_discussions.reduce(['']) do |all_tags, discussion|
      all_tags.concat(discussion.list_tags)
    end.uniq
    index = 0
    list.each_with_object(Hash.new(0)) do |tag, hash|
      hash[index] = tag.to_s
      index += 1
    end
  end

  def find_discussion_by_tag(index)
    @list_discussions.filter do |discussion|
      discussion.tag?(index)
    end
  end

  def censored(word_form)
    @list_discussions.reduce(0) do |sum, discussion|
      sum + discussion.censored(word_form)
    end
  end
end
