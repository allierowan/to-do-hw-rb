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

  def test_get_lists_active_to_dos
    groceries = List.create!(name: "Groceries")
    groceries.to_dos.build(description: "Apples")
    groceries.save!
    get "/lists/#{List.last.name}/active?id=#{List.last.id}"
    assert_match(/Apples/, last_response.body)
  end

  def test_post_to_do_to_list
    groceries = List.create!(name: "Groceries")
    post "/todos", "todo" => { id: groceries.id, description: "Buy an apple" }, "list" => { name: "Groceries" }
    assert_equal 302, last_response.status
    assert_equal "Buy an apple", ToDo.find(groceries.id).description
  end

  def test_patch_to_do_item_inside_list
    groceries = List.create!(name: "Groceries")
    apple = groceries.to_dos.build(description: "Apple")
    apple.save
    groceries.save!
    patch "/list/active/todos/#{apple.id}", "todo" => { is_complete: true }, "list" => { name: "Groceries" }
    assert ToDo.last.is_complete
  end

  def test_delete_to_do_item_inside_list
    groceries = List.create!(name: "Groceries")
    apple = groceries.to_dos.build(description: "Apple")
    apple.save!
    groceries.save!
    delete "/list/all/todos/#{apple.id}", "list" => { name: "Groceries" }
    refute ToDo.find_by(id: apple.id)
  end

  def test_delete_list
    groceries = List.create!(name: "Groceries")
    delete "/lists/#{groceries.name}?id=#{groceries.id}"
    refute List.find_by(id: groceries.id)
  end

  def test_get_all_todos
    apple = ToDo.create!(description: "Apples")
    orange = ToDo.create!(description: "Orange", is_complete: true)
    List.create!(name: "Groceries", to_dos: [apple, orange])
    get "/lists/#{List.last.name}/all?id=#{List.last.id}"
    assert_match(/Orange/, last_response.body)
  end

  def test_get_all_todos_all_lists
    apple = ToDo.create!(description: "Apples")
    orange = ToDo.create!(description: "Orange")
    List.create!(name: "Groceries", to_dos: [apple])
    List.create!(name: "Groceries2", to_dos: [orange])
    get "/all/todos"
    assert_match(/Apples/, last_response.body)
    assert_match(/Orange/, last_response.body)
    assert_match(/Groceries/, last_response.body)
  end

  def test_show_single_to_do
    apple = ToDo.create!(description: "Apples")
    List.create!(name: "Groceries", to_dos: [apple])
    get "/todos/#{apple.id}"
    assert_match(/Apple/, last_response.body)
  end
end
