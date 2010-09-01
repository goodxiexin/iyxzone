require 'ferret'

namespace :mini_blogs do

  task :random => :environment do
    ids = MiniBlog.random(:limit => 100).map(&:id)
    # 如果审核不通过了怎么办
    MiniBlogMetaData.first.update_attributes(:random_ids => ids)
  end

  task :main_index => :environment do
    MiniBlog.build_main_index

    `chown deployer:deployer #{File.join(RAILS_ROOT, MiniBlog.index_dir)}`
  end

  task :delta_index => :environment do
    MiniBlog.build_delta_index 

    `chown deployer:deployer #{File.join(RAILS_ROOT, MiniBlog.index_dir)}`
  end
  
  task :make_snapshot => :environment do
    s = Time.now
    MiniBlog.make_index_snapshot
    e = Time.now
    puts "#{e-s} sec to make new snapshot"
  end

  task :clean_obsolete_snapshots => :environment do
    s = Time.now
    MiniBlog.clean_index_snapshots_before 1.week.ago
    e = Time.now
    puts "#{e-s} sec to clean snapshots"
  end

  task :compute_rank => :environment do
    s = Time.now
    hot_topics = []
    range = [6.hours.ago, 1.day.ago, 2.day.ago, 7.day.ago]
    range.each do |from|
      to = Time.now
      snapshots = MiniBlog.get_index_snapshots_between from, to
      terms = []
      if !snapshots.blank?
        old_ss = snapshots.first
        old_terms = old_ss.terms
        ss = snapshots.last
        ss.terms.each do |term, freq|
          old_freq = old_terms["#{term}"]
          old_freq = 0 if old_freq.nil?
          if freq != old_freq and !(term =~ /\d+/) and term.length > 1
            if term =~ /[0-9a-zA-Z]+/
              terms << [term, freq - old_freq]
            else
              word = RMMSeg::Dictionary.get_word term
              # 上面的freq是指在我们网站中的freq, 这个word.freq是指这个词（在中文）中的freq
              if !word.nil? and ((word.cixing == 1 and word.freq < 100000000) or word.cixing == 17)
                terms << [term, freq - old_freq]
              end
            end
          end
        end
        terms.sort!{|a,b| b[1]<=>a[1]}
      end
      hot_topics.push terms
    end
    meta_data = MiniBlogMetaData.first
    meta_data.update_attributes(:hot_topics => hot_topics)
    e = Time.now
    puts "rank #{e-s} s"
  end

end
