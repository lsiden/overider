# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "overider/version"

Gem::Specification.new do |s|
  s.name        = "overider"
  s.version     = Overider::VERSION
  s.authors     = ["Larry Siden, Westside Consulting LLC"]
  s.email       = ["lsiden@westside-consulting.com"]
  s.homepage    = "https://github.com/lsiden/overider"
  s.summary     = %q{
A mix-in module that allows for super-clean method over-riding without resorting to =alias= 
or making unbound methods visible.
  }
  s.description = %q{
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

    A.new.hello # ==> "hello overide"
  }

  s.rubyforge_project = "overider"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
