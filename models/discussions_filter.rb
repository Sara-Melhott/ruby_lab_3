# frozen_string_literal: true

# Для хранения хеша фильтров сортировки списка обсуждений
module DiscussionFilter
  @filter = {
    'sort_date' => 'По дате создания',
    'sort_last_message' => 'По дате последнего сообщения',
    'sort_number_uniq_user_name' =>
    'По количеству уникальных имен пользователей'
  }

  def self.filter
    @filter.dup
  end
end
