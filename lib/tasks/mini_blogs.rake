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

  # 保存2周内的，这样如果是每10分钟make snapshot，那就是保存6 * 24 * 14 个ss文件
  task :clean_obsolete_snapshots => :environment do
    s = Time.now
    MiniBlog.clean_index_snapshots_before 2.week.ago
    e = Time.now
    puts "#{e-s} sec to clean snapshots"
  end

  task :compute_rank => :environment do
    s = Time.now
    hot_topics = []
    times = [2.minutes, 1.day, 2.days, 7.days]

    #
    # 对每个取3个snapshot，比如对6.hours.ago
    # 取最近6个小时的，和上个6个小时的
    # 这是为了计算趋势
    #
    times.each do |time|
      t1 = Time.now
      t2 = t1 - time
      t3 = t2 - time
      s1 = MiniBlog.get_index_snapshot_before t1
      s2 = MiniBlog.get_index_snapshot_before t2
      s3 = MiniBlog.get_index_snapshot_before t3
      terms = []
      if !s1.blank?
        terms1 = s1.terms
        terms2 = s2.nil? ? {} : s2.terms
        terms3 = s3.nil? ? {} : s3.terms
        terms1.each do |term, freq1|
          freq2 = terms2["#{term}"].nil? ? 0 : terms2["#{term}"]
          freq3 = terms3["#{term}"].nil? ? 0 : terms3["#{term}"]
          trend = ((freq1 - freq2) >= (freq2 -freq3))
          if freq1 != freq2 and !(term =~ /\d+/) and term.length > 1
            if term =~ /[0-9a-zA-Z]+/
              terms << [term, freq1 - freq2, trend]
            else
              word = RMMSeg::Dictionary.get_word term
              # 上面的freq是指在我们网站中的freq, 这个word.freq是指这个词（在中文）中的freq
              if !word.nil? and ((word.cixing == 1 and word.freq < 100000000) or word.cixing == 17)
                terms << [term, freq1 - freq2, trend]
              end
            end
          end
        end
        terms.sort!{|a,b| b[1]<=>a[1]}
      end
      hot_topics.push terms[0..49]
    end
    meta_data = MiniBlogMetaData.first
    meta_data.update_attributes(:hot_topics => hot_topics)
    e = Time.now
    puts "rank #{e-s} s"
  end

end
