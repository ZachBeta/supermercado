require 'block'

class Miner
  def my_genesis
    { hostname => 1000 }
  end

  def coin
    Chain.coin
  end

  def hostname
    @x ||= %w[ alice bob carol ].sample
  end

  def data(last_block_data)
    new_data = Hash.new(0)
    new_data.merge! last_block_data
    new_data[hostname] += 1000

    new_data
  end

  def chain
    p "#{hostname} - #{coin}"

    10.times do
      if latest = Chain.latest
        Block.next(latest, data(latest['data']))
      else
        Block.first( my_genesis )
      end
    end
  end
end
