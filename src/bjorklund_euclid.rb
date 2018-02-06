def euclid(k, n)
  return [] if n == 0 || k == 0

  bins = []
  remainders = []
  k.times { |i| bins[i] = [true] }
  (n-k).times { |i| remainders[i] = [false] }

  return bins.flatten if n == k

  loop do
    new_remainders = []
    bins.each_with_index do |bin, i|
      if remainders.empty?
        new_remainders.push bin
      else
        bin += remainders.shift
        bins[i] = bin
      end
    end

    if new_remainders.any?
      bins.pop new_remainders.count
      remainders = new_remainders
    end

    break unless remainders.size > 1
  end

  return (bins + remainders).flatten
end

Rhythm = Struct.new :weight, :pattern, :position do

  def initialize(weight, *args)
    super weight, euclid(*args), 0
  end

  def tick!
    pattern[position].tap do
      self.position += 1
      self.position = position % pattern.length
    end
  end

  def at_start?
    position == 0
  end

end

def combine(sequence_length, *rhythms)
  [].tap do |steps|
    step = 0
    loop do
      ticks = rhythms.select &:tick!
      step += ticks.map(&:weight).sum
      step = step % sequence_length
      steps.push ticks.any? ? step : nil
      break if step == 0 and rhythms.all? &:at_start?
    end
  end.map { |n| n + 1 if n }
end
