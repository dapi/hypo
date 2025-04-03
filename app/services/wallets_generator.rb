class WalletsGenerator
  attr_reader :seed, :mnemonic

  def initialize(mnemonic)
    @mnemonic = mnemonic
    @seed = Derivator::Mnemonic.seed mnemonic
  end

  def wallet(index)
    Bip44::Wallet.from_seed(seed, "m/44'/60'/0'/0/#{index}")
  end
end
