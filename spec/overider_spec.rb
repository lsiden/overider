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
end
