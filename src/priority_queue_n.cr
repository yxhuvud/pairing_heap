require "./pairing_heap_n"

class PriorityQueueN(P, V, SIZE)
  def initialize
    @heap = PairingHeap::HeapN(P, V, SIZE).new
  end

  def size
    @heap.size
  end

  def insert(value : V, priority : P)
    @heap.insert(priority, value)
  end

  def clear
    @heap.clear
  end

  def empty?
    @heap.empty?
  end

  def find_min : V
    v = @heap.find_min
    v.value
  end

  def pull : V
    @heap.delete_min[1]
  end

  def pull?
    if val = @heap.delete_min?
      val[1]
    end
  end
end
