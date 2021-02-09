require 'spec_helper'
require 'redis-activesupport'

module ActiveSupport
  module Cache
    describe MultiStore do
      it 'has a version number' do
        expect(::MultiStore::VERSION).not_to be nil
      end

      let(:memory_store) { MemoryStore.new }
      let(:redis_store) { RedisStore.new }
      let(:stores) { [memory_store, redis_store] }
      subject { MultiStore.new(*stores) }

      context 'when the input is a double level array' do
        let(:stores) { [[ memory_store, redis_store ], {}] }

        it 'still initializes the stores correctly' do
          expect{ subject }.not_to raise_error
        end
      end

      context 'when neither cache has the key' do
        context '#read' do
          it 'returns nil' do
            expect(subject.read('unknown')).to be_nil
          end
        end

        context '#write' do
          it 'adds to all' do
            expect(subject.write('unknown', 'some value')).to eq([true, "OK"])
            expect(memory_store.read('unknown')).to eq('some value')
            expect(redis_store.read('unknown')).to eq('some value')
          end
        end

        context '#delete' do
          it 'does nothing' do
            expect(subject.delete('unknown')).to eq([false, 1])
            expect(memory_store.read('unknown')).to be_nil
            expect(redis_store.read('unknown')).to be_nil
          end
        end
      end

      context 'when the first cache has the key' do
        before { memory_store.write('key', 'value') }

        context '#read' do
          it 'returns value' do
            expect(subject.read('key')).to eq('value')
            expect(redis_store.read('key')).to be_nil
          end
        end

        context '#write' do
          context 'and we are updating the key' do
            it 'adds to all' do
              expect(subject.write('key', 'some other value')).to eq([true, "OK"])
              expect(memory_store.read('key')).to eq('some other value')
              expect(redis_store.read('key')).to eq('some other value')
            end
          end
          it 'adds to all' do
            expect(subject.write('key', 'value')).to eq([true, "OK"])
            expect(memory_store.read('key')).to eq('value')
            expect(redis_store.read('key')).to eq('value')
          end
        end

        context '#delete' do
          it 'deletes from all' do
            expect(subject.delete('key')).to eq([true, 1])
            expect(memory_store.read('key')).to be_nil
            expect(redis_store.read('key')).to be_nil
          end
        end
      end
      context 'when the second cache has the key' do
        before { redis_store.write('key', 'value') }

        context '#read' do
          it 'returns value and promotes' do
            expect(subject.read('key')).to eq('value')
            expect(memory_store.read('key')).to eq('value')
          end
        end

        context '#write' do
          context 'and we are updating the key' do
            it 'adds to all' do
              expect(subject.write('key', 'some other value')).to eq([true, "OK"])
              expect(memory_store.read('key')).to eq('some other value')
              expect(redis_store.read('key')).to eq('some other value')
            end
          end
          it 'adds to all' do
            expect(subject.write('key', 'value')).to eq([true, "OK"])
            expect(memory_store.read('key')).to eq('value')
            expect(redis_store.read('key')).to eq('value')
          end
        end

        context '#delete' do
          it 'deletes from all' do
            expect(subject.delete('key')).to eq([false, 1])
            expect(memory_store.read('key')).to be_nil
            expect(redis_store.read('key')).to be_nil
          end
        end
      end

      context 'when both caches have the key' do
        before { memory_store.write('key', 'value') }
        context 'and they are the same value' do
          before { redis_store.write('key', 'value') }

          context '#read' do
            it 'returns value' do
              expect(subject.read('key')).to eq('value')
            end
          end

          context '#write' do
            context 'and we are updating the key' do
              it 'adds to all' do
                expect(subject.write('key', 'some other value')).to eq([true, "OK"])
                expect(memory_store.read('key')).to eq('some other value')
                expect(redis_store.read('key')).to eq('some other value')
              end
            end
            it 'adds to all' do
              expect(subject.write('key', 'value')).to eq([true, "OK"])
              expect(memory_store.read('key')).to eq('value')
              expect(redis_store.read('key')).to eq('value')
            end
          end

          context '#delete' do
            it 'deletes from all' do
              expect(subject.delete('key')).to eq([true, 1])
              expect(memory_store.read('key')).to be_nil
              expect(redis_store.read('key')).to be_nil
            end
          end
        end
        context 'and they are different values' do
          before { redis_store.write('key', 'value2') }

          context '#read' do
            it 'returns value' do
              expect(subject.read('key')).to eq('value')
              expect(redis_store.read('key')).to eq('value2')
            end
          end

          context '#write' do
            context 'and we are updating the key' do
              it 'adds to all' do
                expect(subject.write('key', 'some other value')).to eq([true, "OK"])
                expect(memory_store.read('key')).to eq('some other value')
                expect(redis_store.read('key')).to eq('some other value')
              end
            end
            it 'adds to all' do
              expect(subject.write('key', 'value')).to eq([true, "OK"])
              expect(memory_store.read('key')).to eq('value')
              expect(redis_store.read('key')).to eq('value')
            end
          end

          context '#delete' do
            it 'deletes from all' do
              expect(subject.delete('key')).to eq([true, 1])
              expect(memory_store.read('key')).to be_nil
              expect(redis_store.read('key')).to be_nil
            end
          end
        end
      end
    end
  end
end
