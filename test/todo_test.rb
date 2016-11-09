require "./test/test_helper"

class ToDoTest < Minitest::Test
  def test_class_exits
    assert ToDo
  end

  def test_can_create_to_do
    groceries = ToDo.new(description: "Buy groceries", is_complete: false)
    assert groceries.save
  end
end
