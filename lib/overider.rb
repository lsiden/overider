require "overider/version"

module Overider
  def overide(sym, &pr)
    orig_unbound_method = self.instance_method(sym)

    define_method(sym) do |*a, &blk|
      orig_self = self
      obj = Object.new

      obj.define_singleton_method(:overiden) do |*a, &blk|
        orig_bound_method = orig_unbound_method.bind(orig_self)
        if !!blk then
          orig_bound_method.call *a, &blk
        else
          orig_bound_method.call *a
        end
      end

      if !!blk then
        a.push blk.to_proc
      end
      obj.instance_exec(*a, &pr)
    end
  end
end
