module TelegramBot
  class Subgraph
    attr_reader :name, :options

    def initialize(name, options = {}, &block)
      @name = name
      @options = options
      @nodes = {}
      @edges = {}
      @inherit_context = options[:inherit_context] || false

      instance_eval(&block) if block_given?
    end

    def node(name, &block)
      @nodes[name] = Node.new(name, &block)
    end

    def edge(from, to, options = {})
      @edges[from] = @edges[from] || []
      @edges[from] << Edge.new(to, options)
    end

    def apply_to(graph)
      # Copy nodes and edges to the main graph
      @nodes.each do |name, node|
        graph.class.nodes["#{self.name}_#{name}"] = node
      end

      @edges.each do |from, edges|
        edges.each do |edge|
          from_node = "#{self.name}_#{from}"
          to_node = edge.target.start_with?(self.name) ? edge.target : "#{self.name}_#{edge.target}"

          graph.class.edges[from_node] = graph.class.edges[from_node] || []
          graph.class.edges[from_node] << Edge.new(to_node, {
            when: edge.condition,
            data: edge.data,
            retry: edge.retry_count
          })
        end
      end
    end
  end
end