# frozen_string_literal: true

require_relative '../lib/coin'

describe Coin do
  it { expect { described_class.new(3) }.to raise_error(ArgumentError) }

  described_class::COINS.each do |coin|
    it { expect(described_class.new(coin).value).to eq(coin) }
  end
end
