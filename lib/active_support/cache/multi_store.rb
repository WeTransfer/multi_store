module ActiveSupport
  module Cache
    class MultiStore < Store
      def initialize(*stores)
        @monitor = Monitor.new
        @stores = stores
        super(stores.extract_options!)
      end

      def self.send_to_all(*methods)
        methods.each do |method|
          define_method method do |*args|
            synchronize do
              @stores.map { |store| store.send(method, *args) }
            end
          end
        end
      end

      send_to_all :delete_matched, :increment, :decrement, :cleanup, :clear

      protected
        # Read an entry from the cache implementation. Subclasses must implement
        # this method.
        def read_entry(key, options) # :nodoc:
          @stores.each_with_index do |store, index|
            entry = store.send(:read_entry, key, options)
            if entry && !entry.expired?
              promote_entry(key, entry, index)
              return entry
            end
          end
          nil
        end

        send_to_all :write_entry, :delete_entry

      private
        def synchronize(&block) # :nodoc:
          @monitor.synchronize(&block)
        end

        def promote_entry(key, entry, index)
          @stores.first(index).each do |store|
            store.write(key, entry.value)
          end
        end
    end
  end
end
