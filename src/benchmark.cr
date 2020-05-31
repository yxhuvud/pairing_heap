require "benchmark"

require "./heap"
require "./priority_queue"
require "./priority_queue16"

values = 1_000_000.times.map { rand(Int32::MAX) }.to_a
constant_size = 20000

Benchmark.bm do |x|
  queue = PriorityQueue(Int32, Int32).new
  x.report("sort") {
    values.sort
  }

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

  results1 = Array(Int32).new(initial_capacity: values.size)
  queue3 = PriorityQueue(Int32, Int32).new
  x.report("mine - mixed") {
    values.each_with_index do |v, i|
      queue3.insert(v, v)
      if i % 7 == 3
        results1 << queue3.pull
      end
    end
  }

  results2 = Array(Int32).new(initial_capacity: values.size)
  queue6 = PriorityQueue(Int32, Int32).new
  x.report("mine - constant size") {
    values.each_with_index do |v, i|
      queue6.insert(v, v)
      if i >= constant_size
        results2 << queue6.pull
      end
    end
  }

  queue7 = PriorityQueue16(Int32, Int32).new
  x.report("mine16 - insert") {
    values.each do |v|
      queue7.insert(v, v)
    end
  }
  x.report("mine16 - delete") {
    values.size.times do |v|
      queue7.pull
    end
  }

  results4 = Array(Int32).new(initial_capacity: values.size)
  queue4 = PriorityQueue16(Int32, Int32).new
  x.report("mine16 - mixed") {
    values.each_with_index do |v, i|
      queue4.insert(v, v)
      if i % 7 == 3
        # results4 <<
        queue4.pull
      end
    end
  }

  #  results8 = Array(Int32).new(initial_capacity: values.size)
  queue8 = PriorityQueue16(Int32, Int32).new
  x.report("mine16 - constant size") {
    values.each_with_index do |v, i|
      queue8.insert(v, v)
      if i >= constant_size
        #        results8 <<
        queue8.pull
      end
    end
  }
end
