class Node < ApplicationRecord
  belongs_to :account

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
      transition failed_to_start: :finishing
      transition failed_to_finish: :finishing
      transition processing: :finishing
    end

    event :finished do
      transition finishing: :finished
    end
  end
end
