class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  has_many :checkins

  def checkins_info
    Checkin.get_scope_checkins(self.checkins.includes(:hotel))
  end

  def my_info
    { name: self.name, email: self.email }
  end
end
