require "./test/test_helper"

class ListTest < Minitest::Test
  def test_class_exits
    assert List
  end

  def test_can_create_to_do
    household = List.new(name: "Household Items")
    assert household.save
  end
end
