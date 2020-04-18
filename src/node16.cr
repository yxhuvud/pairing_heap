module PairingHeap
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
      while index > 0 && @items[index &- 1].key > key
        @items[index] = @items[index &- 1]
        index &-= 1
      end
      @items[index] = Node(K, V).new(key, value)
      @size += 1
      index
    end

    def delete_min
      item = @items[0]
      (@size &- 1).times do |i|
        @items[i] = @items[i &+ 1]
      end
      @size &-= 1
      (@items.to_unsafe + @size).clear
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
