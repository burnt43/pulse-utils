module PulseUtils
  module Parsers
    class ListSinkInputs
      FIRST_LINE_REGEX = /\A(\d+) sink/
      START_OF_SINK_INPUT = /\Aindex: (\d+)/
      ATTR_REGEX = /\A([\w\s]+):(\s(.*))?\z/
      PROP_REGEX = /\A([\w\.\-]+)\s=\s"(.*)"\z/

      def initialize(raw_data)
        @raw_data = raw_data
      end

      def debug(msg)
        return
        puts "[\033[0;34mDEBUG\033[0;0m] - #{msg}"
      end

      def parse
        {sink_inputs: {}}.tap do |result|
          current_index    = nil
          current_attr_key = nil
          state            = :looking_for_first_line

          first_line_found = ->(match_data) {
            result[:number_available] = match_data.captures[0].to_i
            state = :looking_for_sink_input

            debug("\033[0;33mfirst_line_found\033[0;0m: \033[0;32mnumber_available\033[0;0m=#{result[:number_available]}, \033[0;32mstate\033[0;0m=#{state}")
          }

          new_sink_input_found = ->(match_data) {
            state = :reading_sink_input_attrs
            current_index = match_data.captures[0].to_i
            result[:sink_inputs][current_index] = {}

            debug("\033[0;33mnew_sink_input_found\033[0;0m: \033[0;32mcurrent_index\033[0;0m=#{current_index} \033[0;32mstate\033[0;0m=#{state}")
          }

          attr_found = ->(match_data) {
            key = match_data.captures[0].to_sym
            value = match_data.captures[2]

            current_attr_key = key

            if key == :properties
              result[:sink_inputs][current_index][current_attr_key] = {}
              state = :reading_sink_input_properties
            else
              result[:sink_inputs][current_index][current_attr_key] = value
            end

            debug("\033[0;33mattr_found\033[0;0m: \033[0;32mcurrent_attr_key\033[0;0m=#{current_attr_key} \033[0;32mvalue\033[0;0m=#{value}")
          }

          value_continuation_found = ->(value) {
            result[:sink_inputs][current_index][current_attr_key].concat(" #{value}")
          }

          property_found = ->(match_data) {
            split_prop_name = match_data.captures[0].split('.').map(&:to_sym)
            value = match_data.captures[1]

            index = 0

            result[:sink_inputs][current_index][current_attr_key] ||= {}
            split_prop_name.reduce(result[:sink_inputs][current_index][current_attr_key]) do |h, k|
              index += 1
              if index == split_prop_name.size
                h[k] = value
              else
                h[k] ||= {}
              end
            end

            debug("\033[0;33mproperty_found\033[0;0m: \033[0;32msplit_prop_name\033[0;0m=#{split_prop_name.to_s} \033[0;32mvalue\033[0;0m=#{value}")
          }

          @raw_data.lines.each do |l|
            line = l.strip

            case state
            when :looking_for_first_line
              if (match_data = FIRST_LINE_REGEX.match(line))
                first_line_found.call(match_data)
              end
            when :looking_for_sink_input
              if (match_data = START_OF_SINK_INPUT.match(line))
                new_sink_input_found.call(match_data)
              end
            when :reading_sink_input_attrs
              if (match_data = ATTR_REGEX.match(line))
                attr_found.call(match_data)
              elsif (match_data = START_OF_SINK_INPUT.match(line))
                new_sink_input_found.call(match_data)
              else
                value_continuation_found.call(line)
              end
            when :reading_sink_input_properties
              if (match_data = PROP_REGEX.match(line))
                property_found.call(match_data)
              end
            end
          end
        end
      end
    end
  end
end
