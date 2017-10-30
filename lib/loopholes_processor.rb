require 'source_processor'

module DistributionChallenge
  class LoopholesProcessor < SourceProcessor

    SOURCE = 'loopholes'

    private

    def construct_data_to_send
      node_pairs = entities['node_pairs'].map do |node_pair|
        node_pair_id = node_pair['id']
        [node_pair_id, node_pair]
      end.to_h

      @data_to_send = entities['routes'].map do |route|
        node_pair_id = route['node_pair_id']
        node_pair = node_pairs[node_pair_id]
        next unless node_pair
        {
          start_node: node_pair['start_node'],
          end_node: node_pair['end_node'],
          start_time: route['start_time'],
          end_time: route['end_time']
        }
      end.compact
    end
  end
end
