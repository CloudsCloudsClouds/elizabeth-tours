class Backup < ApplicationRecord
  BACKUP_DIR = Rails.root.join("db/backups")

  validates :name, presence: true, uniqueness: true

  after_destroy :remove_file

  def self.create_backup!(name:)
    raise "pg_dump not found" unless system("which pg_dump > /dev/null 2>&1")

    FileUtils.mkdir_p(BACKUP_DIR)

    ts = Time.now.strftime("%Y%m%d%H%M%S")
    filename = "#{ts}_#{name.parameterize}.dump"
    full_path = BACKUP_DIR.join(filename)

    config = ActiveRecord::Base.connection_db_config.configuration_hash
    db = config[:database]

    backup = create!(name:, file_path: full_path.to_s, file_size: 0, database: db)

    unless system("pg_dump", "-Fc", "-f", full_path.to_s, db)
      backup.destroy!
      raise "pg_dump failed"
    end

    backup.update_column(:file_size, File.size(full_path))
    backup
  end

  def self.restore!(id)
    find(id).restore!
  end

  def restore!
    raise "Restore file not found: #{backup_full_path}" unless backup_full_path.exist?
    raise "pg_restore not found" unless system("which pg_restore > /dev/null 2>&1")

    config = ActiveRecord::Base.connection_db_config.configuration_hash
    db_name = config[:database]

    conn = ActiveRecord::Base.connection
    quoted_db = conn.quote(db_name)

    conn.execute(<<~SQL.squish)
      SELECT pg_terminate_backend(pg_stat_activity.pid)
      FROM pg_stat_activity
      WHERE pg_stat_activity.datname = #{quoted_db}
        AND pid <> pg_backend_pid()
    SQL

    conn.execute("DROP SCHEMA public CASCADE")
    conn.execute("CREATE SCHEMA public")
    conn.execute("GRANT ALL ON SCHEMA public TO public")

    raise "pg_restore failed" unless system("pg_restore", "--dbname=#{db_name}", backup_full_path.to_s)

    ActiveRecord::Base.connection.reconnect!
    true
  end

  private

  def remove_file
    backup_full_path.delete if backup_full_path.exist?
  end

  def backup_full_path
    Pathname.new(file_path)
  end
end