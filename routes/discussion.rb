# frozen_string_literal: true

# Описаны маршруты для страниц приложения Анонимного форума
class AnonForumApp
  hash_branch('discussions') do |r|
    r.is do
      @list_discussions = opts[:discussions]
                          .sort_discussions(r.params['tag'], r.params['filter'])
      view('discussion/discussions')
    end

    r.on 'new_discussion' do
      r.post do
        @disc_form = DryResultFormeWrapper.new(DiscussionSchema.call(r.params))
        if @disc_form.success?
          opts[:discussions].add_discussion_from_form(@disc_form[:name],
                                                      @disc_form[:list_tags])
          r.redirect '/discussions'
        else
          view('discussion/new_discussion')
        end
      end

      r.is do
        @disc_form = {}
        view('discussion/new_discussion')
      end
    end

    r.on 'new_message', Integer do |id|
      @id = id

      r.post do
        @message_form = DryResultFormeWrapper.new(MessageSchema.call(r.params))
        if @message_form.success?
          opts[:discussions].add_message(id, @message_form[:user_name],
                                         @message_form[:text])
          r.redirect "/discussions/#{id}"
        else
          view('discussion/new_message')
        end
      end

      r.is do
        @message_form = {}
        view('discussion/new_message')
      end
    end

    r.on 'censored' do
      @number_censored = nil

      r.post do
        @word = DryResultFormeWrapper.new(CensoredSchema.call(r.params))
        if @word.success?
          @number_censored = opts[:discussions].censored(@word[:word])
          r.redirect "/discussions/censured_succses/#{@number_censored}"
        else
          view('discussion/censored')
        end
      end

      r.is do
        @word = {}
        view('discussion/censored')
      end
    end

    r.on 'censured_succses', Integer do |number_censored|
      r.is do
        @number_censored = number_censored
        view('discussion/censured_succses')
      end
    end

    r.get Integer do |id|
      @discussion = opts[:discussions].discussion(id)
      @list_messages = opts[:discussions].sorted_messages(id)
      next unless @discussion

      view('discussion/discussion_messages')
    end
  end
end
