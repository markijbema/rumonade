module Rumonade
  module Monad
    def self.included(base)
      base.class_eval do
        alias_method :flat_map, :bind
      end
    end

    include Enumerable

    def map(lam = nil, &blk)
      bind { |v| (lam || blk).call(v) }
    end

    def each(lam = nil, &blk)
      map(lam || blk); nil
    end

    def shallow_flatten
      bind { |x| x.is_a?(Monad) ? x : self.class.unit(x) }
    end

    def flatten
      bind { |x| x.is_a?(Monad) ? x.shallow_flatten : self.class.unit(x) }
    end
  end
end
