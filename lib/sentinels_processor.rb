require 'source_processor'

module DistributionChallenge
  class SentinelsProcessor < SourceProcessor

    SOURCE = 'sentinels'

    private

    def end_time(time_string, node_time)
      start_time = DateTime.parse(time_string).to_time.utc
      end_time = start_time + node_time['duration_in_milliseconds'] / 1000
      end_time.to_s
    end

    def construct_data_to_send
      @data_to_send = entities['routes'].map do |route|
        {
          start_node: route['node'],
          end_node: route['node'],
          start_time: route['time'],
          end_time: route['time']
        }
      end
    end
  end
end
