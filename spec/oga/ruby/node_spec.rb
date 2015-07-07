require 'spec_helper'

describe Oga::Ruby::Node do
  describe '#type' do
    it 'returns the type of the node as a Symbol' do
      node = described_class.new('foo')

      node.type.should == :foo
    end
  end

  describe '#to_a' do
    it 'returns the children of the Node as an Array' do
      node = described_class.new(:foo, %w{10})

      node.to_a.should == %w{10}
    end
  end

  describe '#assign' do
    it 'returns an assignment Node' do
      left  = described_class.new(:lit, %w{number})
      right = described_class.new(:lit, %w{10})
      node  = left.assign(right)

      node.type.should == :assign
      node.to_a.should == [left, right]
    end
  end

  describe '#eq' do
    it 'returns an equality Node' do
      left  = described_class.new(:lit, %w{number})
      right = described_class.new(:lit, %w{10})
      node  = left.eq(right)

      node.type.should == :eq
      node.to_a.should == [left, right]
    end
  end

  describe '#and' do
    it 'returns a boolean and Node' do
      left  = described_class.new(:lit, %w{number})
      right = described_class.new(:lit, %w{10})
      node  = left.and(right)

      node.type.should == :and
      node.to_a.should == [left, right]
    end
  end

  describe '#or' do
    it 'returns a boolean or Node' do
      left  = described_class.new(:lit, %w{number})
      right = described_class.new(:lit, %w{10})
      node  = left.or(right)

      node.type.should == :or
      node.to_a.should == [left, right]
    end
  end

  describe '#is_a?' do
    it 'returns a is_a? call Node' do
      left = described_class.new(:lit, %w{number})
      node = left.is_a?(String)

      node.type.should == :send

      node.to_a[0].should == left
      node.to_a[1].should == 'is_a?'

      node.to_a[2].type.should == :lit
      node.to_a[2].to_a.should == %w{String}
    end
  end

  describe '#add_block' do
    it 'returns a block Node' do
      left  = described_class.new(:lit, %w{number})
      arg   = described_class.new(:lit, %w{10})
      body  = described_class.new(:lit, %w{20})
      block = left.add_block(arg) { body }

      block.type.should == :block
      block.to_a.should == [left, [arg], body]
    end
  end

  describe '#if_true' do
    it 'returns an if-statement Node' do
      condition = described_class.new(:lit, %w{number})
      body      = described_class.new(:lit, %w{10})
      statement = condition.if_true { body }

      statement.type.should == :if
      statement.to_a.should == [condition, body]
    end
  end

  describe '#else' do
    it 'returns an if-statement with an else clause' do
      condition = described_class.new(:lit, %w{number})
      body      = described_class.new(:lit, %w{10})
      or_else   = described_class.new(:lit, %w{20})
      statement = condition.if_true { body }.else { or_else }

      statement.type.should == :if
      statement.to_a.should == [condition, body, or_else]
    end
  end

  describe '#followed_by' do
    it 'returns a Node chaining two nodes together' do
      node1  = described_class.new(:lit, %w{A})
      node2  = described_class.new(:lit, %w{B})
      joined = node1.followed_by(node2)

      joined.type.should == :begin
      joined.to_a.should == [node1, node2]
    end
  end

  describe '#method_missing' do
    it 'returns a send Node' do
      receiver = described_class.new(:lit, %w{foo})
      arg      = described_class.new(:lit, %w{10})
      call     = receiver.foo(arg)

      call.type.should == :send
      call.to_a.should == [receiver, 'foo', arg]
    end
  end

  describe '#inspect' do
    it 'returns a String' do
      node = described_class.new(:lit, %w{10})

      node.inspect.should == '(lit "10")'
    end
  end
end
