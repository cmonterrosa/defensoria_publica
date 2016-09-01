class CreateOrigens < ActiveRecord::Migration
  def self.up
    execute "DROP TABLE IF EXISTS `origens`;"
    create_table :origens do |t|
      t.column :descripcion, :string, :limit => 40
    end
    execute "ALTER TABLE `origens` modify COLUMN id int(11) NOT NULL AUTO_INCREMENT;"
    Origen.reset_column_information
    Origen.create(:descripcion => "MESTIZO")
    Origen.create(:descripcion => "INDIGENA")
    Origen.create(:descripcion => "INMIGRANTE")
    Origen.create(:descripcion => "EXTRANJERO")
  end

  def self.down
    drop_table :origens
  end
end
