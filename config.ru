#bundle exec rackup 
#curl localhost::9292/expenses/2017-06-10 -w "\n"
require_relative 'app/api'
run ExpenseTracker::API.new