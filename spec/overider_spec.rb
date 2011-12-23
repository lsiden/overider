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
        overiden(1, 2, 3) + " C"
      end
    end

    result = D.new.hello do
      "I say " 
    end
    result.should == "hello 1, 2, 3 C"
  end

  it 'works with procs' do
    module HelloModule
      def hello(*a, &blk)
        (!!blk ? blk.call : '') + "hello"
      end
    end

    class D
      include HelloModule
      extend Overider

      overide :hello do |*a, &blk|
puts blk.inspect
instance_exec(*a) &blk
        #overiden(*a, &blk) + " C"
      end
    end

    result = D.new.hello do
      "I say " 
    end
    result.should == "I say hello C"
  end
end
