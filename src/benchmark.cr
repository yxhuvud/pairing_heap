require "benchmark"

require "./heap"
require "./priority_queue"

values = 1_000_000.times.map { rand(200_000_000) }.to_a
constant_size = 2000

Benchmark.bm do |x|
  queue = PriorityQueue(Int32, Int32).new
  x.report("mine - insert") {
    values.each do |v|
      queue.insert(v, v)
    end
  }
  x.report("mine - delete") {
    values.size.times do |v|
      queue.pull
    end
  }

  results1 = Array(Int32 | Nil).new
  queue3 = PriorityQueue(Int32, Int32).new
  x.report("mine - mixed") {
    values.each_with_index do |v, i|
      queue3.insert(v, v)
      if i % 4 == 3
        results1 << queue3.pull
      end
    end
  }

  results1 = Array(Int32 | Nil).new
  queue6 = PriorityQueue(Int32, Int32).new
  x.report("mine - constant size") {
    values.each_with_index do |v, i|
      queue6.insert(v, v)
      if i > constant_size
        queue6.pull
      end
    end
  }

  queue2 = PriorityQueue2(Int32).new
  x.report("crystalline - push") {
    values.each do |v|
      queue2.push(v, v)
    end
  }
  x.report("crystalline - pop") {
    values.size.times do |v|
      queue2.pop
    end
  }

  queue4 = PriorityQueue2(Int32).new
  x.report("crystalline - mixed") {
    values.each_with_index do |v, i|
      queue4.push(v, v)
      if i % 4 == 3
        queue4.pop
      end
    end
  }

  queue5 = PriorityQueue2(Int32).new
  x.report("crystalline - constant size") {
    values.each_with_index do |v, i|
      queue5.push(v, v)
      if i > constant_size
        queue4.pop
      end
    end
  }
end
