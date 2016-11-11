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

  post "/lists" do
    @list = List.new(params)
    if @list.save
      redirect "/lists"
    else
      erb :"lists/new.html", layout: :"layout/application.html"
    end
  end

  get "/lists/:id" do
    @list = List.find(params["id"])
    @todo = ToDo.new(list: @list)
    erb :"lists/show.html", layout: :"layout/application.html"
  end

  delete "/lists/:id" do
    List.find(params["id"]).destroy
    redirect "/lists"
  end

  post "/todos" do
    @todo = ToDo.new(params["todo"])
    if @todo.save
      redirect "/lists/#{@todo.list_id}"
    else
      erb :"todos/new.html", layout: :"layout/application.html"
    end
  end

  get "/todos" do
    @todos = ToDo.all.select { |todo| !todo.is_complete }
    erb :"todos/index.html", layout: :"layout/application.html"
  end

  get "/all/todos" do
    @todos = ToDo.all
    @all = true
    erb :"todos/index.html", layout: :"layout/application.html"
  end

  get "/todos/:id" do
    @todo = ToDo.find(params["id"])
    erb :"todos/show.html", layout: :"layout/application.html"
  end

  patch "/todos/:id" do
    @todo = ToDo.find(params["id"])
    @todo.mark_complete! if params["todo"]["is_complete"]
    @todo.update!(params["todo"])
    redirect "/lists/#{@todo.list_id}"
  end

  patch "/todos/all/:id" do
    @todo = ToDo.find(params["id"])
    @todo.mark_complete! if params["todo"]["is_complete"]
    @todo.update!(params["todo"])
    redirect "/all/todos"
  end

  delete "/todos/:id" do
    ToDo.find(params["id"]).destroy
    redirect "/lists/#{params['list_id']}"
  end

  get "/lists/:id/all" do
    @list = List.find(params["id"])
    @todo = ToDo.new(list: @list)
    erb :"lists/show_all.html", layout: :"layout/application.html"
  end
end
