module PulseUtils
  module Parsers
    class ListSinkInputs
      FIRST_LINE_REGEX = /\A(\d+) sink/
      START_OF_SINK_INPUT = /\Aindex: (\d+)/
      ATTR_REGEX = /\A(\w+): (.*)\z/

      def initialize(raw_data)
        @raw_data = raw_data
      end

      def parse
        {sink_inputs: {}}.tap do |result|
          current_index = nil
          state = :looking_for_first_line

          first_line_found = ->(match_data) {
            result[:number_available] = match_data.captures[0].to_i
            state = :looking_for_sink_input
          }

          new_sink_input_found = ->(match_data) {
            state = :reading_sink_input_attrs
            current_index = match_data.captures[0].to_i
            result[:sink_inputs][current_index] = {}
          }

          write_to_current = ->(key, value) {
            result[:sink_inputs][current_index][key] = value
          }

          attr_found = ->(match_data) {
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
              end
            end

            puts line
          end
        end
      end
    end
  end
end
