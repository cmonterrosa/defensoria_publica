class Role < ActiveRecord::Base
  has_and_belongs_to_many :users

  validates_uniqueness_of :prioridad, :allow_blank => true
  

  ##### TODOS LOS USUARIOS ACTIVOS  ######
  def active_users
    return User.find_by_sql("SELECT users.* from users inner join roles_users ru on users.id=ru.user_id
                             INNER JOIN roles r on ru.role_id=r.id
                             WHERE users.activo=true AND r.name='#{self.name}'")
  end

  def no_users
    return User.find_by_sql("SELECT users.*, ru.*
            FROM users users
            LEFT OUTER JOIN roles_users AS ru ON users.id=ru.user_id
            WHERE ru.role_id IS NULL OR ru.role_id not in (select id from roles where name = '#{self.name}')")
  end

  def self.search(search)
    (search)? find(:all,  :conditions => ['name LIKE ?', "%#{search}%"]) : find(:all)
  end


end