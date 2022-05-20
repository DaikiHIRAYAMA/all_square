class LineBotsController < ApplicationController
    require 'line/bot'
    before_action :validate_signature
   
    # POST '/callback'
    def callback
      body = request.body.read
      events = client.parse_events_from(body)
   
      events.each { |event|
        case event
        when Line::Bot::Event::Message
          case event.type
          when Line::Bot::Event::MessageType::Text
            message = {
              type: 'text',
              text: event.message['text']
            }
            client.reply_message(event['replyToken'], message)
          when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
            response = client.get_message_content(event.message['id'])
            tf = Tempfile.open("content")
            tf.write(response.body)
          when Line::Bot::Event::MessageType::Sticker
            client.reply_message(
              event['replyToken'],
              { type: 'text', text: 'すたんぷありがとう' }
            )
          end
        end
      }
      render status: 200 , json: nil
    end
   
    private
    def client
      @client ||= Line::Bot::Client.new { |config|
        # config/secret.yml などに設定した変数を読み込むとよい
        config.channel_secret = f39480de4a19a7f64e924d563a7ae0e0
        config.channel_token  = MG+WLFjPzVf14dyysPDH8tQhvZm9CFYqNl8ff2Wks1F1/yHDuk6UaOiQYxvcHb3vmOH29/DM90cinBJMZe/NHkUUy20lR5cSbfZxlUDrJXjlS+yh/0xLRmgw7r6cYrzj1OunXHPuL5+6s7z6fING8gdB04t89/1O/w1cDnyilFU=
      }
    end
   
    def validate_signature
      body = request.body.read
      signature = request.env['HTTP_X_LINE_SIGNATURE']
      unless client.validate_signature(body, signature)
        error 400 do 'Bad Request' end
      end
    end
   
  end
