require 'lita'
require 'lita/adapters/twitter/connector'

module Lita
  module Adapters
    class Twitter < Adapter
      require_configs :api_key, :api_secret, :access_token, :access_token_secret

      def initialize(robot)
        super
        @connector = Connector.new(robot,
          api_key:             config.api_key,
          api_secret:          config.api_secret,
          access_token:        config.access_token,
          access_token_secret: config.access_token_secret,
        )
      end
      attr_reader :connector

      # Twitter does not support these methods.
      def join; end
      def part; end
      def set_topic; end

      def send_messages(target, strings)
        connector.message(target, strings)
      end

      def run
        robot.trigger(:connected)
        connector.connect
      rescue Interrupt
        shut_down
      end

      def shut_down
        connector.shut_down
        robot.trigger(:disconnected)
      end

      def mention_format(name)
        "@#{name}"
      end

      private
      def config
        Lita.config.adapter
      end

      def debug
        config.debug || false
      end

      Lita.register_adapter(:twitter, Twitter)
    end
  end
end