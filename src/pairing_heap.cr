require "./priority_queue"
module PairingHeap
  class Heap(K, V)
    property size

    private property root : Node(K, V)?

    def initialize
      @size = 0
      @root = nil
    end

    def find_min
      return nil if empty?
      root
    end

    def insert(key : K, value : V)
      node = Node(K, V).new(key, value)
      @size += 1
      @root = merge(root, node)

      node
    end

    def delete_min
      if r = root
        delete(r)
      end
    end

    def delete(node : Node(K, V))
      key = node.key
      value = node.value
      r = root
      if node == r
        @root = collapse(node.child)
      else
        prev = node.prev.not_nil!
        if prev.child == node
          prev.child = node.next
        else
          prev.next = node.next
        end
        n = node.next
        if n
          n.prev = node.prev
        end
        @root = merge(root, collapse(node.child))
      end

      @size -= 1

      {key, value}
    end

    def merge(a : Node(K, V) | Nil, b : Node(K, V) | Nil)
      if a.nil?
        return b
      elsif b.nil?
        return a
      elsif a == b
        return a
      end

      if b.key > a.key
        parent = b
        child = a
      else
        parent = a
        child = b
      end

      child.next = parent.child

      current_child = parent.child
      if current_child
        current_child.prev = child
      end
      child.prev = parent
      parent.child = child

      parent.next = nil
      parent.prev = nil

      parent
    end

    def decrease_key(node : Node(K, V), new_key : K)
      raise "New key must be < old key but wasn't" if node.key < new_key
      node.key = new_key
      return if node == root

      # node.prev.not_nil! safe because not being root implies having
      # a prev.
      prev = node.prev.not_nil!
      if prev.child == node
        prev.child = node.next
      else
        prev.next = node.next
      end

      if n = node.next
        n.prev = node.prev
      end

      @root = merge(root, node)
    end

    def clear
      @size = 0
      @root = nil
    end

    def empty?
      @size == 0
    end

    protected def collapse(node)
      return nil unless node

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

      result = nil
      while tail
        n = tail.prev
        result = merge(result, tail)
        tail = n
      end

      result
    end

    class Node(K, V)
      protected property child : Node(K, V) | Nil
      protected property next : Node(K, V) | Nil
      protected property prev : Node(K, V) | Nil

      property key : K
      property value : V

      def initialize(key : K, value : V)
        @key = key
        @value = value
      end
    end
  end
end
