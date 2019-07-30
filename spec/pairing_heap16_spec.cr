require "./spec_helper"

def tree_size(heap, display=false)
  puts if display
  if r = heap.@root
    queue = Deque(typeof(r)).new([r])
    seen = Set(typeof(r)).new
    count = 0
    while el = queue.pop?
      puts el.to_s if display
      raise "already visited #{el.to_s}" if seen.includes?(el)
      seen << el
      count += 1
      n, c = el.@next, el.@child
      p "n: from #{el.find_min}" if n && display
      queue.push n if n
      p "c: from #{el.find_min}" if c && display
      queue.push c if c
    end
    count
  else
    0
  end
end

describe PairingHeap do
  describe "#initialize" do
    it "Initializes" do
      heap = PairingHeap::Heap16(UInt32, Int32).new
      heap.empty?.should be_true
    end
  end

  describe "#insert" do
    it "is not empty anymore" do
      heap = PairingHeap::Heap16(UInt32, Int32).new

      heap.insert(5_u32, 42)
      heap.empty?.should_not be_true
    end
  end

  describe "#find_min" do
    it "finds the inserted value" do
      heap = PairingHeap::Heap16(UInt32, Int32).new
      heap.find_min?.should eq nil

      heap.insert(5_u32, 42)
      heap.find_min.key.should eq 5
      heap.size == 1

      heap.insert(6_u32, 42)
      heap.find_min.key.should eq 5
      heap.size == 2

      heap.insert(4_u32, 42)
      heap.find_min.key.should eq 4
      heap.size == 3
    end
  end

  describe "delete_min" do
    it "finds the inserted value" do
      heap = PairingHeap::Heap16(UInt32, Int32).new
      heap.insert(5_u32, 43)
      heap.insert(6_u32, 44)
      heap.insert(4_u32, 42)

      heap.find_min.key.should eq 4
      heap.delete_min.should eq({4, 42})

      heap.find_min.key.should eq 5
      heap.delete_min.should eq({5, 43})

      heap.find_min.key.should eq 6
      heap.delete_min.should eq({6, 44})

      heap.find_min?.should be_nil
      heap.delete_min?.should be_nil
      heap.empty?.should be_true
    end

    it "collapses right" do
      heap = PairingHeap::Heap16(Int32, Int32).new
      heap.insert(2, 0)
      heap.insert(2, 0)
      heap.insert(8, 0)
      heap.insert(10, 0)
      heap.delete_min.should eq({2, 0})
      heap.delete_min.should eq({2, 0})
      heap.delete_min.should eq({8, 0})
      heap.delete_min.should eq({10, 0})
      heap.empty?.should be_true
    end
  end

  pending "decrease_key" do
    # Not supported yet for the heap16 case. Perhaps never?
    it "decreases the key" do
      heap = PairingHeap::Heap16(UInt32, Int32).new
      heap.insert(6_u32, 42)
      node = heap.insert(7_u32, 42)
      heap.insert(4_u32, 42)

      heap.decrease_key node, 7_u32
      heap.find_min.key.should eq 4

      heap.decrease_key node, 5_u32
      heap.find_min.key.should eq 4

      heap.decrease_key node, 3_u32
      heap.find_min.key.should eq 3
    end
  end

  describe "slates" do
    it "handles 17 values" do
      heap = PairingHeap::Heap16(Int32, Int32).new
      values = [12, 3, 6, 17, 13, 10, 14, 8, 4, 16, 9, 2, 15, 1, 11, 5, 7]
      values.each do |value|
        heap.insert(value, value)
      end
      heap.size.should eq 17
      heap.empty?.should_not be_true

      tree_size(heap).should eq 2

      vals = [] of Int32
      while v = heap.delete_min?
        vals << v[1]
      end
      tree_size(heap).should eq 0

      vals.should eq values.sort
    end

    it "handles 33 values (ie 3 slates)" do
      heap = PairingHeap::Heap16(Int32, Int32).new
      values = [32, 6, 29, 20, 11, 13, 31, 14, 33, 9, 30, 26, 1, 22, 23, 3, 16, 4, 12, 2, 15, 24, 10, 7, 8, 18, 28, 17, 27, 25, 21, 19, 5]
      values.each do |value|
        heap.insert(value, value)
      end
      tree_size(heap).should eq 3
      vals = [] of Int32
      while v = heap.delete_min?
        vals << v[1]
      end
      vals.should eq values.sort
    end


    it "handles a million values" do
      heap = PairingHeap::Heap16(Int32, Int32).new
      values = (1..1_000_000).to_a
      to_insert = values.shuffle
      to_insert.each do |value|
        heap.insert(value, value)
      end
      vals = [] of Int32
      while v = heap.delete_min?
        vals << v[1]
      end

      vals.should eq values
    end
  end
end
