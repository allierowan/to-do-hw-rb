class ToDo < ActiveRecord::Base
  belongs_to :list

  def mark_complete!
    self.is_complete = true
    self.completed_at = DateTime.now
  end
end
