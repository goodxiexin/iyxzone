require 'pty'
require 'expect'
require 'aws/s3'

def exec_as user_name, &block
  `su #{user_name}`
  yield
  `exit`
end

namespace :utils do

  desc "重启所有rails需要的程序"
  task :restart => :environment do
    exec_as "root" do
      # restart mysql
      `service mysqld restart`
      # restart httpd
      `service httpd restart`
      # restart postfix
      `service postfix restart`
      # restart impad
      `service cyrus-imapd restart`
      # synchronize time
      `ntpdate 0.centos.pool.ntp.org`
      # start memcached
      `memcached -m 256 -u deployer`
    end
    exec_as "deployer" do
      # juggernaut
      `juggernaut -c juggernaut.yml -P tmp/pids/juggernaut.yml -l log/juggernaut.log -d`
    end
  end

  desc "备份mysql到本地硬盘"
  task :backup_local do
    backup = LocalBackup.new
    options = YAML::load(File.read("#{RAILS_ROOT}/config/mysql_backup.yml"))
    databases = options['databases']

    databases.each do |database|

    # synchronize time
      if backup.store database
        puts "successfully backup: #{database}"
      else
        puts "fail to backup: #{database}"
      end
    end
  end
  
  desc "备份到amazon S3上"
  task :backup_s3 do |t, args|
    options = YAML::load(File.open("#{RAILS_ROOT}/config/s3_backup.yml"))
    databases = options['databases']

    local = LocalBackup.new
    s3 = S3Backup.new
    databases.each do |database|
      file = local.latest_backup_for database
      if file.nil?
        puts "no backup for #{database}, run rake utils:backup_local first"
      else
        if s3.store database, File.basename(file), file
          puts "s3 backup success: #{database}, #{file}"
        else
          puts "s3 backup fail: #{database}, #{file}"
        end
      end
    end
  end

  desc "从amazon S3上恢复"
  task :restore_s3, [:database] do |t, args|
    s3 = S3Backup.new
    local = LocalBackup.new
    dir = local.create_dir_for args.database
    file = s3.recover args.database, dir
    if !file.nil?
      puts "recover #{args.database}: #{file} successfully"
    else
      puts "s3 recover fail"
    end
  end

end

#
# 负责将数据库备份到本地
#
class LocalBackup

  def initialize
    options = YAML::load(File.read("#{RAILS_ROOT}/config/mysql_backup.yml"))
    @user = options['user']
    @password = options['password']
    @dir = options['dir']
    @host = options['host']
    @mysqldump_options = options['mysqldump']['options']
    @keep = options['keep']
  end

  def store database
    db_dir = create_dir_for database
    file = File.join(db_dir, "#{Time.now.strftime(time_format)}.sql")
    # mysql dump
    mysql_dump database, file
    # gzip
    gzip file
    # keep latest backups
    keep_latest_backups db_dir
  rescue
    return false
  end

  def keep_latest_backups db_dir
    all = backup_entries_in db_dir
    remove = all - all[0..(@keep - 1)]
    remove.each do |f|
      FileUtils.rm_rf File.join(db_dir, f)
    end
  end

  def latest_backup_for database
    db_dir = File.join(@dir, database)
    return nil if !File.exists?(db_dir)
    all = backup_entries_in db_dir
    all.blank? ? nil : all.first
  end

  def create_dir_for database
    create_dir_if_not_exists @dir
    db_dir = File.join(@dir, database)
    create_dir_if_not_exists db_dir
    db_dir
  end

protected

  def backup_entries_in db_dir
    Dir.entries(db_dir).select {|f| f.match(time_reg)}.select {|f| File.file? File.join(db_dir, f)}.sort_by {|f| File.mtime File.join(db_dir, f)}.reverse.map {|f| File.join(db_dir, f)}
  end

  def create_dir_if_not_exists dir
    if !File.directory?(dir)
      FileUtils.rm_rf dir
      FileUtils.mkdir dir
    end
  end

  def time_format
    "%Y-%m-%d-%H-%M"
  end

  def time_reg
    /\d{4}-\d{2}-\d{2}-\d{2}-\d{2}/
  end
  
  def mysql_dump database, file
    cmd = "mysqldump -u #{@user} -p -h #{@host} #{@mysqldump_options} #{database} --result-file=#{file}"
    PTY.spawn(cmd) do |stdin, stdout, pid|
      stdin.expect(/password/) do
        stdout.puts @password
      end
      stdin.read # 这句貌似必定要有
    end
  end

  def gzip file
    `gzip -fq #{file}`
  end

end

#
# 负责将数据库备份到S3
#
class S3Backup

  include AWS::S3

  def initialize
    options = YAML::load File.open("#{RAILS_ROOT}/config/s3_backup.yml")
    access_key_id = options['access_key_id']
    secret_access_key = options['secret_access_key']

    AWS::S3::Base.establish_connection!(
      :access_key_id     => access_key_id,
      :secret_access_key => secret_access_key
    )
  end

  def store database, version, local_file
    create_bucket_if_not_exists database
    S3Object.store(version, open(local_file), database)
    return true
  end

  def recover database, dir
    bucket = Bucket.find database
    objects = bucket.objects
    object = objects.empty? ? nil : objects.last

    if object.nil?
      "no backup in S3"
    else
      file_name = File.join(dir, object.key)
      open(file_name, 'wb') do |file|
        S3Object.stream(object.key, database) do |chunk|
          file.write chunk
        end
      end
      return file_name
    end
  rescue AWS::S3::NoSuchBucket
    puts "no such bucket: #{database}"
    return nil
  rescue
    puts "unkown error"
    return nil
  end

protected

  def create_bucket_if_not_exists name
    Bucket.find name
  rescue AWS::S3::NoSuchBucket
    Bucket.create name
  end

end
