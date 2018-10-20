require "digest"    # for hash checksum digest function SHA256
require "date"
require "json"
require 'chain'

class Block
  attr_reader :index
  attr_reader :timestamp
  attr_reader :data
  attr_reader :previous_hash
  attr_reader :nonce        ## proof of work if hash starts with leading zeros (00)
  attr_reader :hash

  def difficulty
    "0" * 4
  end

  def to_json
    to_h.to_json
  end

  def to_h
    {
      :index => index,
      :timestamp => timestamp,
      :data => data,
      :previous_hash => previous_hash,
      :nonce => nonce,
      :hash => hash,
    }
  end

  def to_s
    "#{timestamp}: #{hash} #{data}"
  end

  def initialize(index, data, previous_hash)
    @index         = index
    @timestamp     = DateTime.now.iso8601(9)
    @data          = data
    @previous_hash = previous_hash
    claim_block
  end

  def claim_block
    @nonce, @hash = compute_hash_with_proof_of_work
    Chain.claim(self)
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
    sha.update("#{nonce.to_s}#{@index.to_s}#{@timestamp.to_s}#{@data.to_json}#{@previous_hash}" )
    sha.hexdigest
  end

  def self.first( data )    # create genesis (big bang! first) block
    Block.new( 0, data, "0" )
  end

  def self.next( previous, data )
    Block.new( previous['index']+1, data, previous['hash'] )
  end
end  # class Block
