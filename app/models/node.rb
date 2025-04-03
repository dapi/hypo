class Node < ApplicationRecord
  broadcasts_refreshes

  # anvil -f https://binance.safeblock.cc --chain-id 56 --accounts 3 --base-fee 0 --auto-impersonate --no-storage-caching --no-rate-limit \
  # --disable-default-create2-deployer --no-mining --transaction-block-keeper 64 --prune-history 50 \
  # --mnemonic "gate boat total sign print jaguar cache dutch gate universe expect tooth" --port 18545

  ARGUMENTS = {
    "base-fee" => { type: :integer, default: 0 },
    "mnemonic" => { type: :string, default: ApplicationConfig.default_mnemonic },
    "accounts" => { type: :integer, default: 3 }
  }

  # TODO Возможно необходимо удалить из базы
  # EXTRA_ARGUMENTS = {
  # "chain-id" => { type: :chain_id, default: 56 },
  # "block-time" => { type: :integer, default: 0, min: 1, units: :seconds },
  # "prune-history" => { type: :integer, default: 50 },
  # "no-mining" => { type: :boolean, default: true },
  # "auto-impersonate" => { type: :boolean, default: true },
  # "no-storage-caching" => { type: :boolean, default: true },
  # "no-rate-limit" => { type: :boolean, default: true },
  # "disable-default-create2-deployer" => { type: :boolean, default: true },
  # "transaction-block-keeper" => { type: :integer, default: 64 }
  # }

  INTEGER_ARGUMENTS = ARGUMENTS.filter { |k, v| v[:type] == :integer }
  BOOLEAN_ARGUMENTS = ARGUMENTS.filter { |k, v| v[:type] == :boolean }
  OPTIONS = ARGUMENTS.keys.map &:underscore

  belongs_to :account, touch: :nodes_updated_at
  belongs_to :blockchain, primary_key: :chain_id, foreign_key: :chain_id

  scope :alive, -> { where.not state: %i[finishing finished to_finish failed_to_finish] }

  before_create { set_defaults }

  validates :title, uniqueness: { scope: :account_id }
  validates :mnemonic, mnemonic: true

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
      transition initiated: :to_finish
      transition failed_to_start: :to_finish
      transition failed_to_finish: :to_finish
      transition processing: :to_finish
    end

    event :finishing do
      transition to_finish: :finishing
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
    ApplicationConfig.protocol + "://" + ApplicationConfig.node_host + path
  end

  def ws_url
    "wss://" + ApplicationConfig.node_host + path
  end

  def path
    "/" + key
  end

  def destroy_if_unreleased
    destroy! unless orchestrator.exists?
  end

  def arguments
    [ "-f", blockchain.nodex_url ] +
    ARGUMENTS.each_with_object([]) do | (key, definition), agg |
      if definition[:type] == :boolean
        agg << "--" + key.to_s if read_attribute(key.underscore)
      elsif definition[:type] == :string
        agg << "--" + key.to_s
        agg << read_attribute(key.underscore).to_s
      else
        agg << "--" + key.to_s
        agg << read_attribute(key.underscore).to_s
      end
    end
  end

  def wallets
    @wallets ||= accounts.times.map { |i| wallets_generator.wallet i }
  end

  def wallets_generator
    @wallets_generator ||= WalletsGenerator.new(mnemonic)
  end

  def orchestrator
    @orchestrator ||= NodeOrchestrator.new(path: path, node_id: id, account_id: account_id, arguments:)
  end
end
