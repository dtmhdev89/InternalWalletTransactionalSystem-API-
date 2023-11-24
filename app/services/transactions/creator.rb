module Transactions
  class Creator
    attr_reader :wallet, :transaction_params

    def initialize(wallet, transaction_params)
      @wallet = wallet
      @transaction_params = transaction_params.deep_dup
    end

    def perform!
      raise "Not implemented yet"
    end
  end
end
