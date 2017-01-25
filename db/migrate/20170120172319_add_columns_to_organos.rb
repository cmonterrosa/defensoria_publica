class AddColumnsToOrganos < ActiveRecord::Migration
  def self.up
    add_column :organos, :litigantes_id, :integer
    add_column :organos, :ip_server, :string, :limit => 15
  end

  def self.down
    remove_column :organos, :litigantes_id, :integer
    remove_column :organos, :ip_server
  end
end
