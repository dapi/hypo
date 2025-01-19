class Node < ApplicationRecord
  OPTIONS=%i[no_minig block_time chain_id]

  belongs_to :account

  scope :alive, -> { where.not state: %i[finishing finished] }

  before_create { set_defaults }
  validates :title, uniqueness: { scope: :account_id }

  state_machine initial: :initiated do
    event :start do
      transition initiated: :to_start
    end

    event :starting do
      transition to_start: :starting
    end

    event :started do
      transition starting: :processing
    end

    event :failed do
      transition %i[starting to_start initiated] => :failed_to_start
      transition %i[finishing] => :failed_to_finish
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

  def set_defaults
    self.title ||= Faker::App.name
    self.key ||= Nanoid.generate(size: 16)
  end

  def url
    # ApplicationConfig.protocol + "://" + ApplicationConfig.node_host + path
    "http://" + ApplicationConfig.node_host + path
  end

  def path
    "/" + key
  end

  def destroy_if_unreleased
    destroy! unless orchestrator.exists?
  end

  def orchestrator
    @orchestrator ||= NodeOrchestrator.new(path: path, node_id: id, account_id: account_id)
  end
end
