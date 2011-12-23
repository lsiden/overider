require 'rspec'
require 'overider'

describe Overider do
  it 'over-rides method names while allowing access to original method with name "overiden"' do

    class A
      def hello
        "hello"
      end
    end

    # Later, I want to overide class A methods

    class A
      extend Overider

      overide (:hello) do |*a|
        overiden(*a) + " overide"
      end
    end

    a = A.new
    a.hello.should == "hello overide"
  end

  it 'the name "overiden" is not overiden!' do

    class A
      def hello
        "hello"
      end

      def goodby
        "goodby"
      end
    end

    # Later, I want to overide class A methods

    class A
      extend Overider

      overide (:hello) do |*a|
        overiden(*a) + " overide"
      end

      overide (:goodby) do |*a|
        overiden(*a) + " overide"
      end
    end

    a = A.new
    a.hello.should == "hello overide"
    a.goodby.should == "goodby overide"
    a.hello.should == "hello overide" # "overiden" overiden!
  end

  it 'works with inheritance' do

    class B < A
      extend Overider

      overide :hello do |*a|
        overiden(*a) + " B then A"
      end
    end

    B.new.hello.should == "hello overide B then A"
  end

  it 'works with modules' do
    module HelloModule
      def hello
        "hello"
      end
    end

    class C
      include HelloModule
      extend Overider

      overide :hello do |*a|
        overiden(*a) + " C"
      end
    end

    C.new.hello.should == "hello C"
  end

  it 'works with args' do
    module HelloWithArgs
      def hello(a, b, c)
        "hello #{a}, #{b}, #{c}"
      end
    end

    class D
      include HelloWithArgs
      extend Overider

      overide :hello do |a, b, c|
        overiden(a, b, c) + " D"
      end
    end

    result = D.new.hello 1, 2, 3
    result.should == "hello 1, 2, 3 D"
  end

  it 'plays nice with blocks' do
    module HelloModule
      def hello(&blk)
        "hello " + blk.call
      end
    end

    class E
      include HelloModule
      extend Overider

      # In the overide block, we have to declare blk as a normal block arg, not &blk.
      # It must be a Proc or lambda
      overide :hello do |blk|
        overiden { blk.call } + " in E"
      end
    end

    result = E.new.hello do
      "block" 
    end
    result.should == "hello block in E"
  end

  it 'plays nice with lambda' do
    module HelloModule
      def hello(&blk)
        "hello " + blk.call
      end
    end

    class F
      include HelloModule
      extend Overider

      # In the overide block, we have to declare blk as a normal block arg, not &blk.
      # It must be a Proc or lambda
      overide :hello do |blk|
        overiden { blk.call } + " in F"
      end
    end

    result = F.new.hello ->{ "block" }
    result.should == "hello block in F"
  end

  it 'can access instance variables' do
    module HelloModule
      def hello
        "hello "
      end
    end

    class G
      include HelloModule
      extend Overider

      def initialize
        @one = 'one'
        @two = 'two'
      end

      # In the overide block, we have to declare blk as a normal block arg, not &blk.
      # It must be a Proc or lambda
      overide :hello do 
        overiden + "#{@one} and #{@two}"
      end
    end

    result = G.new.hello ->{ "block" }
    result.should == "hello one and two"
  end

  it 'can access instance variables defined in base class' do
    module HelloModule
      def hello
        "hello "
      end
    end

    class H < G
      include HelloModule
      extend Overider

      # In the overide block, we have to declare blk as a normal block arg, not &blk.
      # It must be a Proc or lambda
      overide :hello do 
        overiden + " and again: #{@one} and #{@two}"
      end
    end

    result = H.new.hello ->{ "block" }
    result.should == "hello one and two and again: one and two"
  end
end
