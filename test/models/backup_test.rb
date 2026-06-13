require "test_helper"

class BackupTest < ActiveSupport::TestCase
  setup do
    @dir = Pathname.new(Dir.mktmpdir("backup_test"))
  end

  teardown do
    FileUtils.rm_rf(@dir)
  end

  test "create_backup! creates record and dump file" do
    old_dir = Backup::BACKUP_DIR
    Backup.send(:remove_const, :BACKUP_DIR)
    Backup.const_set(:BACKUP_DIR, @dir)

    backup = Backup.create_backup!(name: "pre_deploy")
    assert backup.persisted?
    assert_equal "pre_deploy", backup.name
    assert_match(/\A#{Regexp.escape(@dir.to_s)}\/\d{14}_pre_deploy\.dump\z/, backup.file_path)
    assert backup.file_size > 0
    assert_equal ActiveRecord::Base.connection_db_config.configuration_hash[:database], backup.database
  ensure
    Backup.send(:remove_const, :BACKUP_DIR)
    Backup.const_set(:BACKUP_DIR, old_dir)
  end

  test "create_backup! requires unique name" do
    old_dir = Backup::BACKUP_DIR
    Backup.send(:remove_const, :BACKUP_DIR)
    Backup.const_set(:BACKUP_DIR, @dir)

    Backup.create_backup!(name: "unique")
    assert_raises(ActiveRecord::RecordInvalid) { Backup.create_backup!(name: "unique") }
  ensure
    Backup.send(:remove_const, :BACKUP_DIR)
    Backup.const_set(:BACKUP_DIR, old_dir)
  end

  test "validates name presence" do
    backup = Backup.new(name: "")
    backup.valid?
    assert_includes backup.errors[:name], "can't be blank"
  end

  test "restore! raises when file missing" do
    backup = Backup.create!(name: "missing", file_path: "/nonexistent.dump", file_size: 0, database: "test")
    error = assert_raises(RuntimeError) { backup.restore! }
    assert_match(/Restore file not found/, error.message)
  end

  test "restore! raises when id not found" do
    assert_raises(ActiveRecord::RecordNotFound) { Backup.restore!(999999) }
  end

  test "deletes file on destroy" do
    file = @dir.join("test_delete.dump")
    File.write(file, "content")
    backup = Backup.create!(name: "delete_test", file_path: file.to_s, file_size: 7, database: "test")
    assert file.exist?
    backup.destroy!
    assert_not file.exist?
  end

  test "deletes file on destroy when file already missing" do
    backup = Backup.create!(name: "ghost", file_path: "/tmp/ghost.dump", file_size: 0, database: "test")
    assert_nothing_raised { backup.destroy! }
  end

  test "listing returns all backups ordered by creation" do
    b1 = Backup.create!(name: "l_first", file_path: "/tmp/a", file_size: 1, database: "test", created_at: 1.day.ago)
    b2 = Backup.create!(name: "l_second", file_path: "/tmp/b", file_size: 2, database: "test", created_at: 1.hour.ago)
    b3 = Backup.create!(name: "l_third", file_path: "/tmp/c", file_size: 3, database: "test", created_at: 1.minute.ago)
    ids = Backup.order(created_at: :desc).pluck(:id)
    assert_equal [b3.id, b2.id, b1.id], ids.first(3)
  end
end