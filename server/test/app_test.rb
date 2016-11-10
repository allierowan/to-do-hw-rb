require_relative "test_helper"
require_relative "../dependencies"

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def setup
    List.delete_all
    ToDo.delete_all
  end

  def app
    App
  end

  def test_list_index_end_point
    List.create!(name: "Groceries")
    response = get "/lists"
    assert response.ok?
    assert_match(/Groceries/, last_response.body)
  end

  def test_post_list_end_point
    payload = { name: "Groceries" }
    post "/lists", payload
    assert_equal 302, last_response.status
    assert List.find_by(name: "Groceries")
  end

  def test_post_list_no_name_goes_to_new_html_with_errors
    post "/lists", name: ""
    assert_match(/Name can\'t be blank/, last_response.body)
  end

  def test_get_lists_to_dos
    groceries = List.create!(name: "Groceries")
    groceries.to_dos.build(description: "Apples")
    groceries.save!
    get "/lists/#{List.last.id}"
    assert_match(/Apples/, last_response.body)
  end

  def test_post_to_do_to_list
    groceries = List.create!(name: "Groceries")
    post "/todos", "todo" => { id: groceries.id, description: "Buy an apple" }
    assert_equal 302, last_response.status
    assert_equal "Buy an apple", ToDo.find(groceries.id).description
  end

  def test_patch_to_do_item
    groceries = List.create!(name: "Groceries")
    apple = groceries.to_dos.build(description: "Apple")
    apple.save
    patch "/todos/#{apple.id}", "todo" => { is_complete: true }
    assert ToDo.last.is_complete
  end

  def test_delete_to_do_item
    groceries = List.create!(name: "Groceries")
    apple = groceries.to_dos.build(description: "Apple")
    apple.save
    delete "/todos/#{apple.id}"
    refute ToDo.find_by(id: apple.id)
  end

  def test_delete_list
    groceries = List.create!(name: "Groceries")
    delete "/lists/#{groceries.id}"
    refute List.find_by(id: groceries.id)
  end
end
