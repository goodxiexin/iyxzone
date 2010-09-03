#
# 快照
# index 的快照，用来以后作分西，目前保存的比较简单，只是每个term的freq
#

module HasIndex

class SnapshotManager

  def initialize klass
    @klass = klass
    @dir = File.join(@klass.index_dir, "snapshots")
    `mkdir -p #{@dir}`
    load_snapshots
  end

  # 最接近time的一个snapshot
  def get_snapshot_before time
    if time.nil?
      nil
    else
      @snapshots.find_all{|snapshot| snapshot.timestamp <= time }.max {|a,b| a.timestamp <=> b.timestamp}
    end
  end

  def make_snapshot
    new_snapshot = Snapshot.create_from_index @klass.indexer, @dir
    @snapshots.push new_snapshot
    new_snapshot
  end

  def clean_snapshots_before ago
    get_snapshots_between(nil, ago).each do |snapshot|
      snapshot.destroy
      @snapshots.delete(snapshot)
    end
  end

protected

  def load_snapshots
    @snapshots = []
    Dir.new(@dir).each do |file|
      @snapshots.push Snapshot.new(File.join(@dir, file)) if file =~ /\.ss$/
    end
  end

end

class Snapshot

  def initialize file
    @file = file
    @terms = nil
    @timestamp = Time.parse file.split(".").first
  end

  def self.create_from_index klass, to_dir
    time = Time.now.strftime("%Y-%m-%d-%H:%M")
    name = File.join(to_dir, "#{time}.ss")
    file = File.open(name, "w")
    klass.reader.terms(:content).each do |term, freq|
      file.write "#{term} #{freq}\n"
    end

    # performance problem when invoking terms, it would parse terms one more time
    snapshot = Snapshot.new name
    snapshot
  end

  def terms
    if @terms.nil? # first time
      parse_terms
    end
    @terms
  end

  def timestamp
    @timestamp
  end

  def destroy
    # remove file
    FileUtils.rm @file
  end

protected

  def parse_terms
    @terms = {}
    f = File.open(@file, "r")
    while str = f.gets
      splits = str.split(" ") 
      term = splits[0]
      freq = splits[1].to_i
      @terms["#{term}"] = freq
    end
  end

end

end
