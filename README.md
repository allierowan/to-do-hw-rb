# to-do-hw-rb

The To-Do app was an Iron Yard assignment in which we were tasked with creating a todo app using Ruby and Sinatra which would track lists of tasks with due dates. It also had a random To Do button which would serve you up with a random task to complete, and a search bar which would allow you to search your tasks. To dos can be completed by clicking the checkmark next to their name, at which point they disappear from the view.

## DB Structure
To Dos belong to lists and lists have many to dos.

## Getting started
Run bundle install to install gem dependencies. Run '$rake db:create' and '$rake db:migrate' to create the mysql database and tables. Navigate to the server directory and run the '$bundle exec rackup' command. This app runs on Sinatra and Active Record.
