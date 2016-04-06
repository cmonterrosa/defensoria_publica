class CreateModificacions < ActiveRecord::Migration
  def self.up
    create_table :modificacions do |t|
      t.column :id_objeto, :integer
      t.column :clase, :string, :limit => 30
      t.column :user_id, :integer
      t.column :is_created, :boolean
      t.timestamps
    end
    add_index :modificacions, [:user_id], :name => "modificacions_user"
    add_index :modificacions, [:id_objeto, :clase, :is_created], :name => "modificacions_primer_registro"
  end

  def self.down
    drop_table :modificacions
  end
end
