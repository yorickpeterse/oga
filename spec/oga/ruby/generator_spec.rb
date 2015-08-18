require 'spec_helper'

describe Oga::Ruby::Generator do
  before do
    @generator = described_class.new
  end

  describe '#on_followed_by' do
    it 'returns a String' do
      node1  = Oga::Ruby::Node.new(:lit, %w{10})
      node2  = Oga::Ruby::Node.new(:lit, %w{20})
      joined = node1.followed_by(node2)

      @generator.on_followed_by(joined).should == "10\n\n20"
    end
  end

  describe '#on_assign' do
    it 'returns a String' do
      var    = Oga::Ruby::Node.new(:lit, %w{number})
      val    = Oga::Ruby::Node.new(:lit, %w{10})
      assign = var.assign(val)

      @generator.on_assign(assign).should == <<-EOF
number = begin
  10
end
      EOF
    end
  end

  describe '#on_mass_assign' do
    it 'returns a String' do
      var1 = Oga::Ruby::Node.new(:lit, %w{foo})
      var2 = Oga::Ruby::Node.new(:lit, %w{bar})
      val  = Oga::Ruby::Node.new(:lit, %w{10})

      assign = Oga::Ruby::Node.new(:massign, [[var1, var2], val])

      @generator.on_massign(assign).should == 'foo, bar = 10'
    end
  end

  describe '#on_begin' do
    it 'returns a String' do
      number = Oga::Ruby::Node.new(:lit, %w{10})
      node   = Oga::Ruby::Node.new(:begin, [number])

      @generator.on_begin(node).should == <<-EOF
begin
  10
end
      EOF
    end
  end

  describe '#on_eq' do
    it 'returns a String' do
      var = Oga::Ruby::Node.new(:lit, %w{number})
      val = Oga::Ruby::Node.new(:lit, %w{10})
      eq  = var.eq(val)

      @generator.on_eq(eq).should == 'number == 10'
    end
  end

  describe '#on_and' do
    it 'returns a String' do
      left      = Oga::Ruby::Node.new(:lit, %w{foo})
      right     = Oga::Ruby::Node.new(:lit, %w{bar})
      condition = left.and(right)

      @generator.on_and(condition).should == 'foo && bar'
    end
  end

  describe '#on_or' do
    it 'returns a String' do
      left      = Oga::Ruby::Node.new(:lit, %w{foo})
      right     = Oga::Ruby::Node.new(:lit, %w{bar})
      condition = left.or(right)

      @generator.on_or(condition).should == '(foo || bar)'
    end
  end

  describe '#on_if' do
    it 'returns a String' do
      statement = Oga::Ruby::Node.new(:lit, %w{foo}).if_true do
        Oga::Ruby::Node.new(:lit, %w{bar})
      end

      @generator.on_if(statement).should == <<-EOF
if foo
  bar
end
      EOF
    end

    describe 'when using an else clause' do
      it 'returns a String' do
        foo = Oga::Ruby::Node.new(:lit, %w{foo})
        bar = Oga::Ruby::Node.new(:lit, %w{bar})
        baz = Oga::Ruby::Node.new(:lit, %w{baz})

        statement = foo.if_true { bar }.else { baz }

        @generator.on_if(statement).should == <<-EOF
if foo
  bar
else
  baz
end
        EOF
      end
    end
  end

  describe '#on_while' do
    it 'returns a String' do
      statement = Oga::Ruby::Node.new(:lit, %w{foo}).while_true do
        Oga::Ruby::Node.new(:lit, %w{bar})
      end

      @generator.on_while(statement).should == <<-EOF
while foo
  bar
end
      EOF
    end
  end

  describe '#on_send' do
    describe 'without arguments' do
      it 'returns a String' do
        node = Oga::Ruby::Node.new(:lit, %w{number}).foobar

        @generator.on_send(node).should == 'number.foobar'
      end
    end

    describe 'with arguments' do
      it 'returns a String' do
        arg  = Oga::Ruby::Node.new(:lit, %w{10})
        node = Oga::Ruby::Node.new(:lit, %w{number}).foobar(arg)

        @generator.on_send(node).should == 'number.foobar(10)'
      end
    end

    describe 'when calling #[]' do
      it 'returns a correctly formatted String' do
        arg  = Oga::Ruby::Node.new(:lit, %w{10})
        node = Oga::Ruby::Node.new(:lit, %w{number})[arg]

        @generator.on_send(node).should == 'number[10]'
      end
    end
  end

  describe '#on_block' do
    describe 'without arguments' do
      it 'returns a String' do
        node = Oga::Ruby::Node.new(:lit, %w{number}).add_block do
          Oga::Ruby::Node.new(:lit, %w{10})
        end

        @generator.on_block(node).should == <<-EOF
number do ||
  10
end
        EOF
      end
    end

    describe 'with arguments' do
      it 'returns a String' do
        arg  = Oga::Ruby::Node.new(:lit, %w{foo})
        node = Oga::Ruby::Node.new(:lit, %w{number}).add_block(arg) do
          Oga::Ruby::Node.new(:lit, %w{10})
        end

        @generator.on_block(node).should == <<-EOF
number do |foo|
  10
end
        EOF
      end
    end
  end

  describe '#on_range' do
    it 'returns a String' do
      start = Oga::Ruby::Node.new(:lit, %w{10})
      stop  = Oga::Ruby::Node.new(:lit, %w{20})
      node  = Oga::Ruby::Node.new(:range, [start, stop])

      @generator.on_range(node).should == '(10..20)'
    end
  end

  describe '#on_string' do
    it 'returns a String' do
      node = Oga::Ruby::Node.new(:string, %w{foo})

      @generator.on_string(node).should == '"foo"'
    end
  end

  describe '#on_symbol' do
    it 'returns a String' do
      node = Oga::Ruby::Node.new(:symbol, [:foo])

      @generator.on_symbol(node).should == ':foo'
    end
  end

  describe '#on_lit' do
    it 'returns a String' do
      node = Oga::Ruby::Node.new(:lit, %w{foo})

      @generator.on_lit(node).should == 'foo'
    end
  end
end
