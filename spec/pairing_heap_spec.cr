require "./spec_helper"
describe PairingHeap do
  describe "#initialize" do
    it "Initializes" do
      heap = PairingHeap::Heap(UInt32, Int32).new
      heap.empty?.should be_true
    end
  end

  describe "#insert" do
    it "is not empty anymore" do
      heap = PairingHeap::Heap(UInt32, Int32).new

      heap.insert(5_u32, 42)
      heap.empty?.should_not be_true
    end
  end

  describe "#find_min" do
    it "finds the inserted value" do
      heap = PairingHeap::Heap(UInt32, Int32).new

      heap.insert(5_u32, 42)
      heap.find_min.not_nil!.key.should eq 5

      heap.insert(6_u32, 42)
      heap.find_min.not_nil!.key.should eq 5

      heap.insert(4_u32, 42)
      heap.find_min.not_nil!.key.should eq 4
    end

  end

  describe "delete_min" do
    it "finds the inserted value" do
      heap = PairingHeap::Heap(UInt32, Int32).new
      heap.insert(5_u32, 43)
      heap.insert(6_u32, 44)
      heap.insert(4_u32, 42)

      heap.find_min.not_nil!.key.should eq 4
      heap.delete_min.not_nil!.should eq({4, 42})

      heap.find_min.not_nil!.key.should eq 5
      heap.delete_min.not_nil!.should eq({5, 43})

      heap.find_min.not_nil!.key.should eq 6
      heap.delete_min.not_nil!.should eq({6, 44})

      heap.find_min.should be_nil
      heap.delete_min.should be_nil
    end

    it "collapses right" do
      heap = PairingHeap::Heap(Int32, Int32).new
      heap.insert(2, 0)
      heap.insert(2, 0)
      heap.insert(8, 0)
      heap.insert(10, 0)
      heap.delete_min.not_nil!.should eq({2, 0})
      heap.delete_min.not_nil!.should eq({2, 0})
      heap.delete_min.not_nil!.should eq({8, 0})
      heap.delete_min.not_nil!.should eq({10, 0})
      heap.empty?.should be_true
    end
  end

  describe "decrease_key" do
    it "decreases the key" do
      heap = PairingHeap::Heap(UInt32, Int32).new
      heap.insert(6_u32, 42)
      node = heap.insert(7_u32, 42)
      heap.insert(4_u32, 42)

      heap.decrease_key node, 7_u32
      heap.find_min.not_nil!.key.should eq 4

      heap.decrease_key node, 5_u32
      heap.find_min.not_nil!.key.should eq 4

      heap.decrease_key node, 3_u32
      heap.find_min.not_nil!.key.should eq 3
    end
  end
end
