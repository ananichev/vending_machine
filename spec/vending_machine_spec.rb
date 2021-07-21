# frozen_string_literal: true

require_relative '../lib/coin'
require_relative '../lib/coin_receiver'
require_relative '../lib/product'
require_relative '../lib/vending_machine'

RSpec.describe VendingMachine do
  let(:product) { Product.new(name: 'CocaCola', price: 150) }
  let(:coin) { Coin.new(25) }
  let(:product_rack) { ProductRack.new([product]) }

  context 'with products' do
    let(:vm) { described_class.new(rack: product_rack) }

    it { expect(vm.list_products).to eq([product.name]) }
  end

  context 'with coins' do
    it { expect { subject.insert(coin) }.to change(subject, :coins_inserted).to(25) }
  end

  it 'raises an error if product is out of stock' do
    expect(subject.select('NonExisting')).to eq('NonExisting is out of stock')
  end

  context 'vend' do
    let(:vm) { described_class.new(rack: product_rack, coin_receiver: CoinReceiver.new(coins: [coin, coin])) }

    it 'vends nothing when the amount is not enough' do
      vm.select(product.name)

      expect(vm.vend).to eq('Insert more coins')
    end

    it 'vends product when the amount is exactly that needed' do
      vm.select(product.name)
      vm.insert(100)
      vm.insert(50)

      expect(vm.vend).to eq([product])
    end

    context 'when the amount exceeds the product price' do
      it 'vends the product and change' do
        vm.select(product.name)
        vm.insert(200)

        expect(vm.vend).to eq([[coin, coin], product])
      end

      it 'raises error if change could not be issued' do
        vm.select(product.name)
        vm.insert(300)

        expect(vm.vend).to eq('No suitable coin to issue')
      end
    end
  end
end
