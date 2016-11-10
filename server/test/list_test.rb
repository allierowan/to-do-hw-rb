require "./test/test_helper"

class ListTest < Minitest::Test
  def setup
    List.delete_all
    ToDo.delete_all
  end

  def test_class_exits
    assert List
  end

  def test_can_create_to_do
    household = List.new(name: "Household Items")
    assert household.save
  end

  def test_list_has_to_dos
    household = List.create!(name: "Household Items")
    groceries = ToDo.create!(description: "Buy Groceries")
    household.to_dos << groceries
    household.save!
    assert_equal [groceries], household.to_dos
  end
end
