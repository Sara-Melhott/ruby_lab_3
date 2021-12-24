# frozen_string_literal: true

require 'roda'
require 'forme'
require_relative 'models'

# Веб-логика приложения отображающего работу Анонимного форума
class AnonForumApp < Roda
  opts[:root] = __dir__
  plugin :hash_routes
  plugin :forme
  plugin :environments
  plugin :render
  plugin :view_options
  plugin :status_handler

  configure :development do
    plugin :public
    opts[:serve_static] = true
  end

  require_relative 'routes/discussion'

  # TODO: Исправить нормально /lab_3/
  opts[:discussions] =
    ListDiscussions.new([],
                        File.expand_path('data/input.json', __dir__))
  opts[:discussions].read_data_json(File.expand_path('data/input.json',
                                                     __dir__))
  opts[:filters] = DiscussionFilter.filter
  puts '[WEB-APPLICATION]: list discussions JSON file reading completed'

  status_handler(404) do
    view('not_found_error')
  end

  route do |r|
    r.public if opts[:serve_static]
    r.hash_branches

    r.root do
      r.redirect '/discussions'
    end
  end
end
