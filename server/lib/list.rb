class List < ActiveRecord::Base
  has_many :to_dos
  validates :name, presence: :true
end
