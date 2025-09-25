# Этот документ описывает методи использования API telegram-bot-rb для работы
телеграм-бота

В контроллере методы в восклицательным знаком являются телеграм-командами:


```ruby
class Telegram::WebhookController < Telegram::Bot::UpdatesController
  # use callbacks like in any other controller
  around_action :with_locale

  # Every update has one of: message, inline_query, chosen_inline_result,
  # callback_query, etc.
  # Define method with the same name to handle this type of update.
  def message(message)
    # store_message(message['text'])
  end

  # For the following types of updates commonly used params are passed as arguments,
  # full payload object is available with `payload` instance method.
  #
  #   message(payload)
  #   inline_query(query, offset)
  #   chosen_inline_result(result_id, query)
  #   callback_query(data)

  # Define public methods ending with `!` to handle commands.
  # Command arguments will be parsed and passed to the method.
  # Be sure to use splat args and default values to not get errors when
  # someone passed more or less arguments in the message.
  def start!(word = nil, *other_words)
    # do_smth_with(word)

    # full message object is also available via `payload` instance method:
    # process_raw_message(payload['text'])

    # There are `chat` & `from` shortcut methods.
    # For callback queries `chat` is taken from `message` when it's available.
    response = from ? "Hello #{from['username']}!" : 'Hi there!'

    # There is `respond_with` helper to set `chat_id` from received message:
    respond_with :message, text: response

    # `reply_with` also sets `reply_to_message_id`:
    reply_with :photo, photo: File.open('party.jpg')
  end
```

## Пример использования сессий:


```ruby
def write!(text = nil, *)
    session[:text] = text
end

def read!(*)
    respond_with :message, text: session[:text]
end

```

## Message context

It's usual to support chain of messages like BotFather: after receiving command it asks you for additional argument. There is MessageContext for this:

```
class Telegram::WebhookController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  def rename!(*)
    # set context for the next message
    save_context :rename_from_message
    respond_with :message, text: 'What name do you like?'
  end

  # register context handlers to handle this context
  def rename_from_message(*words)
    update_name words[0]
    respond_with :message, text: 'Renamed!'
  end

  # You can use same action name as context name:
  def rename!(name = nil, *)
    if name
      update_name name
      respond_with :message, text: 'Renamed!'
    else
      save_context :rename!
      respond_with :message, text: 'What name do you like?'
    end
  end
end
```

## Callback queries

You can include CallbackQueryContext module to split #callback_query into several methods. It doesn't require session support, and takes context from data: if data has a prefix with colon like this my_ctx:smth... it invokes my_ctx_callback_query('smth...') when such action method is defined. Otherwise it invokes callback_query('my_ctx:smth...') as usual. Callback queries without prefix stay untouched.

```
# This one handles `set_value:%{something}`.
def set_value_callback_query(new_value = nil, *)
  save_this(value)
  answer_callback_query('Saved!')
end

# And this one is for `make_cool:%{something}`
def make_cool_callback_query(thing = nil, *)
  do_it(thing)
  answer_callback_query("#{thing} is cool now! Like a callback query context.")
end
```

## Reply helpers

There are helpers for basic responses. They just set chat/message/query identifiers from the update. See ReplyHelpers module for more information. Here are these methods signatures:

```ruby
def respond_with(type, params); end
def reply_with(type, params); end
def answer_inline_query(results, params = {}); end
def answer_callback_query(text, params = {}); end
def edit_message(type, params = {}); end
def answer_pre_checkout_query(ok, params = {}); end
def answer_shipping_query(ok, params = {}); end
```

## Примеры spec-ов (тестов) для телеграм 

Бери отсюда:
* https://github.com/telegram-bot-rb/telegram-bot/blob/master/spec/telegram/bot/rspec/callback_query_helpers_spec.rb
* https://github.com/telegram-bot-rb/telegram-bot/blob/master/spec/telegram/bot/rspec/message_helpers_spec.rb
*** *https://github.com/telegram-bot-rb/telegram-bot/blob/master/spec/telegram/bot/rspec/client_matchers_spec.rb

