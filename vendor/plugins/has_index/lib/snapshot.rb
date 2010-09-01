#
# 快照
# index 的快照，用来以后作分西，目前保存的比较简单，只是每个term的freq
#

module HasIndex

class SnapshotManager

  def initialize indexed_class
    @class = indexed_class
    load_snapshots
  end

  def get_snapshots_between from, to
    return @snapshots if from.nil? and to.nil?

    @snapshots.find_all do |snapshot|
      if from.nil?
        snapshot.timestamp <= to
      elsif to.nil?
        snapshot.timestamp >= from
      else
        snapshot.timestamp >= from and snapshot.timestamp <= to
      end
    end
  end

  def make_snapshot
    new_snapshot = Snapshot.create_from_enum @class.indexer.reader.terms(:content), @class.index_dir
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
    Dir.new(@class.index_dir).each do |file|
      @snapshots.push Snapshot.new(File.join(@class.index_dir, file)) if file =~ /snapshot-/
    end
  end

end

class Snapshot

  def initialize file
    @file = file
    @terms = nil
    @timestamp = Time.parse file.split("snapshot-").last
  end

  def self.create_from_enum enum, to_dir
    time = Time.now.strftime("%Y-%m-%d-%H:%M")
    name = File.join(to_dir, "snapshot-#{time}")
    file = File.open(name, "w")
    enum.each do |term, freq|
      file.write "#{term}  #{freq}\n"
    end

    snapshot = Snapshot.new name
    snapshot.set_terms enum
    snapshot
  end

  def set_terms terms
    @terms = terms
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
