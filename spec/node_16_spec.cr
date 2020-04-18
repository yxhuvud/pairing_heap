require "./spec_helper"

describe PairingHeap::Node16 do
  describe "#initialize" do
    it "Initializes" do
      node = PairingHeap::Node16(Int32, Int32).new(3, 4)

      node.empty?.should be_false
      node.full?.should be_false
      node.@items[0].should eq PairingHeap::Node16::Node(Int32, Int32).new(3, 4)
    end
  end

  describe "#insert" do
    it "inserts second val correctly" do
      node = PairingHeap::Node16(Int32, Int32).new(3, 4)
      node.insert(5, 42)

      node.@items[0].should eq PairingHeap::Node16::Node(Int32, Int32).new(3, 4)
      node.@items[1].should eq PairingHeap::Node16::Node(Int32, Int32).new(5, 42)

      node = PairingHeap::Node16(Int32, Int32).new(3, 4)
      node.insert(2, 42)

      node.@items[0].should eq PairingHeap::Node16::Node(Int32, Int32).new(2, 42)
      node.@items[1].should eq PairingHeap::Node16::Node(Int32, Int32).new(3, 4)
    end

    it "inserts third val correctly" do
      node = PairingHeap::Node16(Int32, Int32).new(3, 4)
      node.insert(5, 42)
      node.insert(6, 6)

      node.@items[0].should eq PairingHeap::Node16::Node(Int32, Int32).new(3, 4)
      node.@items[1].should eq PairingHeap::Node16::Node(Int32, Int32).new(5, 42)
      node.@items[2].should eq PairingHeap::Node16::Node(Int32, Int32).new(6, 6)

      node = PairingHeap::Node16(Int32, Int32).new(3, 4)
      node.insert(5, 42)
      node.insert(2, 6)

      node.@items[0].should eq PairingHeap::Node16::Node(Int32, Int32).new(2, 6)
      node.@items[1].should eq PairingHeap::Node16::Node(Int32, Int32).new(3, 4)
      node.@items[2].should eq PairingHeap::Node16::Node(Int32, Int32).new(5, 42)

      node = PairingHeap::Node16(Int32, Int32).new(3, 4)
      node.insert(6, 42)
      node.insert(5, 6)

      node.@items[0].should eq PairingHeap::Node16::Node(Int32, Int32).new(3, 4)
      node.@items[1].should eq PairingHeap::Node16::Node(Int32, Int32).new(5, 6)
      node.@items[2].should eq PairingHeap::Node16::Node(Int32, Int32).new(6, 42)
    end
  end
end
