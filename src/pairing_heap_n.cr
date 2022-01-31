require "./node_n"

module PairingHeap
  class HeapN(K, V, SIZE)
    property size

    private property root : NodeN(K, V, SIZE)?
    private property inserter : NodeN(K, V, SIZE)?

    def initialize
      @size = 0
      @root = @inserter = nil
    end

    def find_min?
      return nil if empty?

      find_min
    end

    def find_min
      root.not_nil!.find_min
    end

    def insert(key : K, value : V)
      @size += 1

      # Avoid allocating a new inserter unless necessary. Gives a
      # slight improvement to the bounded size case at a minor cost to
      # the insertion case:
      r = @root
      if r && !r.full?
        r.insert(key, value)
        return
      end

      inserter = @inserter
      if !inserter || inserter.full?
        @inserter = NodeN(K, V, SIZE).new(key, value)
        @root = merge(root, @inserter)
      else
        prev = inserter.prev
        new_first = inserter.insert(key, value)
        if new_first && prev && inserter.find_min < prev.find_min
          inserter.unlink
          @root = merge(root, inserter)
        end
      end
      nil
    end

    def delete_min
      r = root.not_nil!
      delete(r)
    end

    def delete_min?
      if r = root
        delete(r)
      end
    end

    def delete(node : NodeN(K, V, SIZE))
      key_val, new_size = node.delete_min
      @size -= 1
      if new_size == 0
        @root = collapse(node.child)
        @inserter = @root if node == @inserter
      elsif child = node.child
        node.child = nil
        @root = merge(collapse(child), node)
      end

      {key_val.key, key_val.value}
    end

    def merge(a : NodeN(K, V, SIZE) | Nil, b : NodeN(K, V, SIZE) | Nil)
      return b if a.nil? || a.empty?
      return a if b.nil? || b.empty?
      return a if a == b

      if a.find_min < b.find_min
        parent = a
        child = b
      else
        parent = b
        child = a
      end
      parent.prepend_child(child)
      parent.next = nil
      parent.prev = nil
      parent
    end

    def clear
      @size = 0
      @root = nil
    end

    def empty?
      @size == 0
    end

    private def collapse(node)
      return nil unless node

      # Collapse uses two phases:
      # First merge every two nodes with each other, and store a
      # reference to the previous pair in prev.
      n = node
      tail = nil
      while n
        a = n
        if b = a.next
          n = b.next
          result = merge(a, b)
          result.prev = tail
          tail = result
        else
          a.prev = tail
          tail = a
          break
        end
      end

      # Then merge all pairs.
      result = nil
      while tail
        n = tail.prev
        result = merge(result, tail)
        tail = n
      end
      result
    end
  end
end
