require 'spec_helper'

describe Oga::Ruby::Node do
  describe '#type' do
    it 'returns the type of the node as a Symbol' do
      node = described_class.new('foo')

      expect(node.type).to eq(:foo)
    end
  end

  describe '#to_a' do
    it 'returns the children of the Node as an Array' do
      node = described_class.new(:foo, %w{10})

      expect(node.to_a).to eq(%w{10})
    end
  end

  describe '#to_array' do
    it 'returns a send Node' do
      number = described_class.new(:lit, %w{10})
      node   = number.to_array

      expect(node.type).to eq(:send)
      expect(node.to_a).to eq([number, :to_a])
    end
  end

  describe '#assign' do
    it 'returns an assignment Node' do
      left  = described_class.new(:lit, %w{number})
      right = described_class.new(:lit, %w{10})
      node  = left.assign(right)

      expect(node.type).to eq(:assign)
      expect(node.to_a).to eq([left, right])
    end
  end

  describe '#eq' do
    it 'returns an equality Node' do
      left  = described_class.new(:lit, %w{number})
      right = described_class.new(:lit, %w{10})
      node  = left.eq(right)

      expect(node.type).to eq(:eq)
      expect(node.to_a).to eq([left, right])
    end
  end

  describe '#and' do
    it 'returns a boolean and Node' do
      left  = described_class.new(:lit, %w{number})
      right = described_class.new(:lit, %w{10})
      node  = left.and(right)

      expect(node.type).to eq(:and)
      expect(node.to_a).to eq([left, right])
    end
  end

  describe '#or' do
    it 'returns a boolean or Node' do
      left  = described_class.new(:lit, %w{number})
      right = described_class.new(:lit, %w{10})
      node  = left.or(right)

      expect(node.type).to eq(:or)
      expect(node.to_a).to eq([left, right])
    end
  end

  describe '#not' do
    it 'returns a send Node' do
      node     = described_class.new(:lit, %w{foo})
      inverted = node.not

      expect(inverted.type).to eq(:send)
      expect(inverted.to_a).to eq([node, '!'])
    end
  end

  describe '#is_a?' do
    it 'returns a is_a? call Node' do
      left = described_class.new(:lit, %w{number})
      node = left.is_a?(String)

      expect(node.type).to eq(:send)

      expect(node.to_a[0]).to eq(left)
      expect(node.to_a[1]).to eq('is_a?')

      expect(node.to_a[2].type).to eq(:lit)
      expect(node.to_a[2].to_a).to eq(%w{String})
    end
  end

  describe '#add_block' do
    it 'returns a block Node' do
      left  = described_class.new(:lit, %w{number})
      arg   = described_class.new(:lit, %w{10})
      body  = described_class.new(:lit, %w{20})
      block = left.add_block(arg) { body }

      expect(block.type).to eq(:block)
      expect(block.to_a).to eq([left, [arg], body])
    end
  end

  describe '#wrap' do
    it 'returns a begin Node' do
      number  = described_class.new(:lit, %w{10})
      wrapped = number.wrap

      expect(wrapped.type).to eq(:begin)
      expect(wrapped.to_a).to eq([number])
    end
  end

  describe '#if_true' do
    it 'returns an if statement Node' do
      condition = described_class.new(:lit, %w{number})
      body      = described_class.new(:lit, %w{10})
      statement = condition.if_true { body }

      expect(statement.type).to eq(:if)
      expect(statement.to_a).to eq([condition, body])
    end
  end

  describe '#if_false' do
    it 'returns an if statement Node' do
      condition = described_class.new(:lit, %w{number})
      body      = described_class.new(:lit, %w{10})
      statement = condition.if_false { body }

      expect(statement.type).to eq(:if)

      expect(statement.to_a[0].type).to eq(:send)

      expect(statement.to_a[0].to_a).to eq([condition, '!'])
      expect(statement.to_a[1]).to      eq(body)
    end
  end

  describe '#while_true' do
    it 'returns a while statement Node' do
      condition = described_class.new(:lit, %w{number})
      body      = described_class.new(:lit, %w{10})
      statement = condition.while_true { body }

      expect(statement.type).to eq(:while)
      expect(statement.to_a).to eq([condition, body])
    end
  end

  describe '#else' do
    it 'returns an if-statement with an else clause' do
      condition = described_class.new(:lit, %w{number})
      body      = described_class.new(:lit, %w{10})
      or_else   = described_class.new(:lit, %w{20})
      statement = condition.if_true { body }.else { or_else }

      expect(statement.type).to eq(:if)
      expect(statement.to_a).to eq([condition, body, or_else])
    end
  end

  describe '#followed_by' do
    describe 'without a block' do
      it 'returns a Node chaining two nodes together' do
        node1  = described_class.new(:lit, %w{A})
        node2  = described_class.new(:lit, %w{B})
        joined = node1.followed_by(node2)

        expect(joined.type).to eq(:followed_by)
        expect(joined.to_a).to eq([node1, node2])
      end
    end

    describe 'with a block' do
      it 'returns a Node chaining two nodes together' do
        node1  = described_class.new(:lit, %w{A})
        node2  = described_class.new(:lit, %w{B})
        joined = node1.followed_by { node2 }

        expect(joined.type).to eq(:followed_by)
        expect(joined.to_a).to eq([node1, node2])
      end
    end
  end

  describe '#method_missing' do
    it 'returns a send Node' do
      receiver = described_class.new(:lit, %w{foo})
      arg      = described_class.new(:lit, %w{10})
      call     = receiver.foo(arg)

      expect(call.type).to eq(:send)
      expect(call.to_a).to eq([receiver, 'foo', arg])
    end
  end

  describe '#inspect' do
    it 'returns a String' do
      node = described_class.new(:lit, %w{10})

      expect(node.inspect).to eq('(lit "10")')
    end
  end
end
