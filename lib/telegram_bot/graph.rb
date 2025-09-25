module TelegramBot
  class Graph
    include ActiveModel::Model

    attr_accessor :current_state, :context, :user_id, :chat_id, :controller

    class << self
      def nodes
        @nodes ||= {}
      end

      def edges
        @edges ||= {}
      end

      def interceptors
        @interceptors ||= []
      end

      def node(name, &block)
        nodes[name] = Node.new(name, &block)
      end

      def edge(from, to, options = {})
        edges[from] = edges[from] || []
        edges[from] << Edge.new(to, options)
      end

      def subgraph(name, options = {}, &block)
        Subgraph.new(name, options, &block)
      end

      def intercept(pattern, &block)
        interceptors << Interceptor.new(pattern, block)
      end
    end

    def initialize(user_id:, chat_id: nil, controller: nil)
      @user_id = user_id
      @chat_id = chat_id
      @controller = controller
      @current_state = :start
      @context = {}
    end

    def start!
      transition_to(:start)
    end

    def handle_message(text)
      apply_interceptors(text)

      if node = self.class.nodes[current_state]
        process_node(node, text)
      else
        raise "Unknown state: #{current_state}"
      end
    end

    def transition_to(new_state, data = {})
      @current_state = new_state
      @context.merge!(data)
      after_transition
    end

    def context_data
      @context.dup
    end

    private

    attr_reader :controller

    def apply_interceptors(text)
      self.class.interceptors.each do |interceptor|
        if interceptor.match?(text)
          instance_exec(text, &interceptor.block)
          return true
        end
      end
      false
    end

    def process_node(node, text)
      case node.action_type
      when :message
        send_message(node.content)
        apply_edges(node)
      when :collect
        handle_collection(node, text)
      when :menu
        show_menu(node)
        apply_edges(node)
      when :multi_select
        handle_multi_select(node, text)
      when :llm_extract
        handle_llm_extract(node, text)
      when :integrate
        handle_integration(node, text)
      end
    end

    def apply_edges(node)
      if edges = self.class.edges[current_state]
        edges.each do |edge|
          if edge.condition.call(context_data)
            transition_to(edge.target, edge.data || {})
            return
          end
        end
      end
    end

    def send_message(text)
      controller.send_message(text, chat_id: chat_id)
    end

    def handle_collection(node, text)
      @context[node.variable] = text
      send_message(node.prompt) if node.prompt
      apply_edges(node)
    end

    def show_menu(node)
      menu_text = node.options.map { |opt| "#{opt[:text]}" }.join("\n")
      send_message("#{node.title}\n#{menu_text}")
    end

    def handle_multi_select(node, text)
      # Implementation for multi-select logic
      selected = text.split(',').map(&:strip)
      @context[node.store_as] = selected
      send_message("Selected: #{selected.join(', ')}")
      apply_edges(node)
    end

    def handle_llm_extract(node, text)
      # Implementation for LLM extraction
      send_message("LLM extraction not implemented yet")
      apply_edges(node)
    end

    def handle_integration(node, text)
      # Implementation for external API integration
      send_message("Integration not implemented yet")
      apply_edges(node)
    end

    def after_transition
      # Hook for post-transition logic
    end
  end
end
