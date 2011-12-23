require "overider/version"

module Overider
  def overide(sym, &pr)
    orig_unbound_method = self.instance_method(sym)

    define_method(sym) do |*a|
      orig_self = self
      obj = Object.new

      obj.define_singleton_method(:overiden) do |*a|
        orig_bound_method = orig_unbound_method.bind(orig_self)

        if (orig_bound_method.arity > 0) then
          orig_bound_method.call(*a)
        else
          orig_bound_method.call
        end
      end
      obj.instance_eval(&pr)
    end
  end
end
