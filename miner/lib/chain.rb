require 'json'

class Chain
  @@coin = %w[alpha bravo charlie].sample

  def latest
    begin
      contents = File.open(filename, "r") { |file|
        file.read
      }
      JSON.parse(contents) if contents.length > 0
    rescue
      nil
    end
  end

  def self.latest
    new.latest
  end

  def self.claim(block)
    new.claim(block)
  end

  def claim(block)
    json = block.to_json

    File.open("#{filename}.lock", "w") { |lock|
      lock.flock(File::LOCK_EX)

      File.open(filename, "a") { |file| }

      File.open(filename, "r") { |file|
        contents = file.read
        next if contents.size == 0
        parsed = JSON.parse(contents)
        if block.index <= parsed['index']
          puts "double mined! #{block.index} <= #{parsed['index']}"
          return
        end
      }

      File.open(filename, "w") { |file|
        file.write(json)
      }

      File.open("#{filename}.log", "a") { |file|
        file.write(json)
        file.write("\n")
      }

      lock.flock(File::LOCK_UN)
    }

  end

  def self.coin
    @@coin
  end

  def filename
    @filename ||= "chain_#{@@coin}_latest.json"
  end
end
