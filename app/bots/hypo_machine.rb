class HypoMachine
  attr_accessor :guide_read_at
  state_machine :state, initial: :parked do
    event :start do
    end
  end
end
