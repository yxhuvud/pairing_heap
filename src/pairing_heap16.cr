require "./priority_queue"

module PairingHeap
  class Heap16(K, V)
    property size

    private property root : Node16(K, V)?
    private property inserter : Node16(K, V)?

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
      inserter = @inserter
      if !inserter || inserter.full?
        @inserter = Node16(K, V).new(key, value)
        @root = merge(root, @inserter)
      else
        prev = inserter.prev
        new_index = inserter.insert(key, value)
        if new_index == 0 && prev && inserter.find_min < prev.find_min
          inserter.unlink
          @root = merge(root, inserter)
        end
      end
      @inserter
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

    def delete(node : Node16(K, V))
      key_val, new_size = node.delete_min
      @size -= 1

      if new_size == 0
        @inserter = nil if node == @inserter
        @root = merge(collapse(node.child), node.next)
      else
        if child = node.child
          node.child = nil
          @root = merge(collapse(child), node)
        end
      end

      {key_val.key, key_val.value}
    end

    def merge(a : Node16(K, V) | Nil, b : Node16(K, V) | Nil)
      return b if a.nil?
      return a if b.nil?
      return a if a == b

      if a.find_min < b.find_min
        parent = a
        child = b
      else
        parent = b
        child = a
      end
      parent.prepend_child(child)
      # TODO: Investigate: Tests pass even if these are not cleared?!?
      # but benchmarks don't work.
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
        b = a.next
        if b
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

    class Node16(K, V)
      SIZE = 16

      protected property child : Node16(K, V) | Nil
      protected property next : Node16(K, V) | Nil
      protected property prev : Node16(K, V) | Nil

      protected property items

      struct Node(K, V)
        include Comparable(self)

        def <=>(other : self)
          key <=> other.key
        end

        property key : K
        property value : V

        def initialize(@key, @value)
        end

        def to_s
          " {#{key.inspect} - #{value.inspect}}"
        end
      end

      def to_s
        "[#{@size} : #{@items.first(@size).map(&.to_s).join(" ")}]"
      end

      def initialize(key : K, value : V)
        @items = uninitialized StaticArray(Node(K, V), SIZE)
        @items[0] = Node(K, V).new(key, value)
        @size = 1
      end

      def initialize(node : Node(K, V))
        @items = uninitialized StaticArray(Node(K, V), SIZE)
        @items[0] = node
        @size = 1
      end

      def full?
        @size == SIZE
      end

      def empty?
        @size == 0
      end

      def insert(key, value)
        index = @size
        while index > 0 && @items[index - 1].key > key
          @items[index] = @items[index - 1]
          index -= 1
        end
        @items[index] = Node(K, V).new(key, value)
        @size += 1
        index
      end

      def delete_min
        item = @items[0]
        (@size - 1).times do |i|
          @items[i] = @items[i + 1]
        end
        @size -= 1

        {item, @size}
      end

      def find_min
        @items[0]
      end

      def prepend_child(new_child : self)
        new_child.next = child
        if ch = child
          ch.prev = new_child
        end
        # note that the first element on each level have pointer to parent:
        new_child.prev = self
        @child = new_child
      end

      def unlink
        # All nodes but the root has a prev, and the root is never
        # unlinked, just dereferenced.
        prev = self.prev.not_nil!
        if prev.child == self # ie, prev references the parent.
          prev.child = self.next
        else
          prev.next = self.next
        end

        if n = self.next
          n.prev = prev
        end
        self
      end
    end
  end
end
