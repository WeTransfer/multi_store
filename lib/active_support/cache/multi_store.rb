module ActiveSupport
  module Cache
    class MultiStore < Store
      def initialize(*stores)
        @stores = stores
        super(stores.extract_options!)
      end
    end
  end
end
