require "./test/test_helper"

class ToDoTest < Minitest::Test
  def test_class_exits
    assert ToDo
  end

  def test_can_create_to_do
    groceries = ToDo.new(description: "Buy groceries", is_complete: false)
    assert groceries.save
  end

  def test_to_do_belongs_to_list
    groceries = ToDo.create!(description: "Buy groceries", is_complete: false)
    household = List.create!(name: "Household Items", to_dos: [groceries])
    assert_equal household, groceries.list
  end

  def test_completing_to_do_changes_completed_time
    groceries = ToDo.create!(description: "Buy groceries", is_complete: false)
    groceries.mark_complete!
    assert groceries.completed_at
  end
end
