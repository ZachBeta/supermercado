$stdout.sync = true

require "digest"    # for hash checksum digest function SHA256
require "pp"        # for pp => pretty printer
require 'date'
require 'json'

class Block
  attr_reader :index
  attr_reader :timestamp
  attr_reader :data
  attr_reader :previous_hash
  attr_reader :nonce        ## proof of work if hash starts with leading zeros (00)
  attr_reader :hash

  def difficulty
    '0' * 5
  end

  def to_s
    "#{timestamp}: #{hash} #{data}"
  end

  def initialize(index, data, previous_hash)
    @index         = index
    @timestamp     = DateTime.now.iso8601(9)
    @data          = data
    @previous_hash = previous_hash
    @nonce, @hash  = compute_hash_with_proof_of_work
    # lock file
    # log newest block
    # unlock file
  end

  def compute_hash_with_proof_of_work
    nonce = 0
    loop do
      hash = calc_hash_with_nonce( nonce )
      if hash.start_with?( difficulty )
        return [nonce,hash]    ## bingo! proof of work if hash starts with leading zeros (00)
      else
        nonce += 1             ## keep trying (and trying and trying)
      end
    end
  end

  def calc_hash_with_nonce( nonce=0 )
    sha = Digest::SHA256.new
    sha.update( nonce.to_s + @index.to_s + @timestamp.to_s + @data.to_json + @previous_hash )
    sha.hexdigest
  end

  def self.first( data )    # create genesis (big bang! first) block
    Block.new( 0, data, "0" )
  end

  def self.next( previous, data )
    Block.new( previous.index+1, data, previous.hash )
  end
end  # class Block

class Miner
  def my_genesis
    {
      hostname => 1000
    }
  end

  def hostname
    ENV['HOSTNAME']
  end

  def data(last_block_data)
    new_data = last_block_data.dup
    new_data[hostname] += 1000

    new_data
  end

  def chain
    p ENV['HOSTNAME']

    b0 = Block.first( my_genesis )
    puts b0

    new_data = data(b0.data)
    b1 = Block.next( b0, new_data)
    puts b1

    b2 = Block.next( b1, data(b1.data))
    puts b2

    b3 = Block.next( b2, data(b2.data))
    puts b3
  end
end

Miner.new.chain
