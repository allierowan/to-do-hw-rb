class List < ActiveRecord::Base
  has_many :to_dos
  validates :name, presence: :true

  def active_todos
    to_dos.select { |to_do| !to_do.is_complete }
  end
end
