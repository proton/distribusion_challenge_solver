require 'source_processor'

module DistributionChallenge
  class SniffersProcessor < SourceProcessor

    SOURCE = 'sniffers'

    private

    def construct_data_to_send
      node_times = entities['node_times'].map do |node_time|
        node_time_id = node_time['node_time_id']
        [node_time_id, node_time]
      end.to_h

      routes = entities['routes'].map do |route|
        route_id = route['route_id']
        [route_id, route]
      end.to_h

      @data_to_send = entities['sequences'].map do |sequence|
        route_id = sequence['route_id']
        route = routes[route_id]

        node_time_id = sequence['node_time_id']
        node_time = node_times[node_time_id]
        next unless node_time

        duration = node_time['duration_in_milliseconds'] / 1000
        start_time = route['time']
        start_time_ts = DateTime.parse(start_time).to_time.utc
        end_time_ts = start_time_ts + duration
        end_time = end_time_ts.strftime('%Y-%m-%dT%H:%M:%S')

        {
          start_node: node_time['start_node'],
          end_node: node_time['end_node'],
          start_time: start_time,
          end_time: end_time
        }
      end.compact
    end
  end
end
