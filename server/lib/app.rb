require "bundler/setup"
require "sinatra"

require_relative "database"
require_relative "../dependencies"

class App < Sinatra::Base
  set :method_override, true

  get "/" do
    erb :"home/index.html", layout: :"layout/application.html"
  end

  get "/lists" do
    @lists = List.all
    erb :"lists/index.html", layout: :"layout/application.html"
  end

  get "/next" do
    if !ToDo.where(is_complete: :false).empty?
      @todo = ToDo.where(is_complete: :false).sample
      redirect "/list/todos/#{@todo.id}"
    else
      @message = "Create some to dos!"
      erb :"home/index.html", layout: :"layout/application.html"
    end
  end

  post "/lists" do
    @list = List.new(params)
    if @list.save
      redirect "/lists"
    else
      erb :"lists/new.html", layout: :"layout/application.html"
    end
  end

  get "/lists/:name/active" do
    @list = List.find(params["id"])
    @todo = ToDo.new(list: @list)
    erb :"lists/show_active.html", layout: :"layout/application.html"
  end

  delete "/lists/:name" do
    List.find(params["id"]).destroy
    redirect "/lists"
  end

  post "/todos" do
    @todo = ToDo.new(params["todo"])
    if @todo.save
      redirect "/lists/#{params['list']['name']}/active?id=#{@todo.list_id}"
    else
      erb :"todos/new.html", layout: :"layout/application.html"
    end
  end

  get "/active/todos" do
    @todos = ToDo.all.select { |todo| !todo.is_complete }
    erb :"todos/index.html", layout: :"layout/application.html"
  end

  get "/all/todos" do
    @todos = ToDo.all
    @all = true
    erb :"todos/index_all.html", layout: :"layout/application.html"
  end

  get "/list/todos/:id" do
    @todo = ToDo.find(params["id"])
    erb :"todos/list_show.html", layout: :"layout/application.html"
  end

  get "/todos/:id" do
    @todo = ToDo.find(params["id"])
    erb :"todos/show.html", layout: :"layout/application.html"
  end

  patch "/list/active/todos/:id" do
    @todo = ToDo.find(params["id"])
    @todo.mark_complete! if params["todo"]["is_complete"]
    @todo.update!(params["todo"])
    redirect "/lists/#{params['list']['name']}/active?id=#{@todo.list_id}"
  end

  patch "/list/all/todos/:id" do
    @todo = ToDo.find(params["id"])
    @todo.mark_complete! if params["todo"]["is_complete"]
    @todo.update!(params["todo"])
    redirect "/lists/#{params['list']['name']}/all?id=#{@todo.list_id}"
  end

  patch "/all/todos/:id" do
    @todo = ToDo.find(params["id"])
    @todo.mark_complete! if params["todo"]["is_complete"]
    @todo.update!(params["todo"])
    redirect "/all/todos"
  end

  patch "/active/todos/:id" do
    @todo = ToDo.find(params["id"])
    @todo.mark_complete! if params["todo"]["is_complete"]
    @todo.update!(params["todo"])
    redirect "/active/todos"
  end

  delete "/list/all/todos/:id" do
    ToDo.find(params["id"]).destroy
    redirect "/lists/#{params['list']['name']}/all?id=#{params['list']['id']}"
  end

  delete "/list/active/todos/:id" do
    ToDo.find(params["id"]).destroy
    redirect "/lists/#{params['list']['name']}/active?id=#{params['list']['id']}"
  end

  delete "/todos/all/:id" do
    ToDo.find(params["id"]).destroy
    redirect "/all/todos"
  end

  delete "/todos/active/:id" do
    ToDo.find(params["id"]).destroy
    redirect "/active/todos"
  end

  get "/lists/:name/all" do
    @all = true
    @list = List.find(params["id"])
    @todo = ToDo.new(list: @list)
    erb :"lists/show_all.html", layout: :"layout/application.html"
  end
end
