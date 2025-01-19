class Node < ApplicationRecord
  OPTIONS=%i[no_minig block_time chain_id]

  belongs_to :account

  scope :alive, -> { where.not state: %i[finishing finished] }

  before_create { self.key ||= Nanoid.generate(size: 32) }
  validates :title, uniqueness: { scope: :account_id }

  state_machine initial: :initiated do
    event :start do
      transition initiated: :starting
    end

    event :started do
      transition starting: :processing
    end

    event :failed do
      transition starting: :failed_to_start
      transition finishing: :failed_to_finish
    end

    event :finish do
      transition initiated: :finishing
      transition failed_to_start: :finishing
      transition failed_to_finish: :finishing
      transition processing: :finishing
    end

    event :finished do
      transition finishing: :finished
    end
  end

  def url
    # ApplicationConfig.protocol + "://" + ApplicationConfig.node_host + path
    "http://" + ApplicationConfig.node_host + path
  end

  def path
    "/" + key
  end

  def orchestrator
    @orchestrator ||= NodeOrchestrator.new(path: path, node_id: id, account_id: account_id)
  end
end
