require "sinatra"
require "./db/connection"

get "/" do
  erb :"home/index.html", layout: :"layout/application.html"
end

get "/lists" do
  @lists = List.all
  erb :"lists/index.html", layout: :"layout/application.html"
end
