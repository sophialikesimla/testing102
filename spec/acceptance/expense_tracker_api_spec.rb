require_relative '../../app/api'
require 'rack/test' 
require 'json'

module  ExpenseTracker #we can nest RSpec contexts inside modules
	RSpec.describe 'Expense Tracker API' do
		include Rack::Test::Methods

		def app
			ExpenseTracker::API.new
		end

		def post_expense(expense) #bc DRY
			post '/expenses', JSON.generate(expense)
		    expect(last_response.status).to eq(200) #Rack::Test provides the last_response method for checking HTTP responses AND Together, expect() and to() check a result in order to signal success or failure.

			parsed = JSON.parse(last_response.body)
			expect(parsed).to include('expense_id' => a_kind_of(Integer)) #The include and a_kind_of matchers let us spell out in general terms what we want: a hash containing a key of 'expense_id' and an integer value.
			expense.merge('id' => parsed['expense_id']) #this line just adds an id key to the hash, containing whatever ID gets auto-assigned from the database
		end

		it 'records submitted expenses' do 
			pending 'need to persist expenses'
			coffee = post_expense(
				'payee' => 'EinsteinCo', #JSON objects convert to Ruby hashes with string keys
				'amount' => 5.75,
				'date' => '2017-06-10'
				)
			exhibition = post_expense(
				'payee' => 'MoMa',
				'amount' => 15.75,
				'date' => '2017-06-10'
				)
			groceries = post_expense(
				'payee' => 'Food',
				'amount' => 30.05,		
				'date' => '2017-06-11'
				)

			get '/expenses/2017-06-10' #using the same techniques from before: driving the app, grabbing the last_response from Rack::Test, and looking at the results
			expect(last_response.status).to eq(200)
			expenses = JSON.parse(last_response.body)
			expect(expenses).to contain_exactly(coffee, exhibition) #here, we want to check that the array con- tains the two expenses we want—and only those two—without regard to the order. The contain_exactly matcher captures this requirement.
			
		end

	end 	
end