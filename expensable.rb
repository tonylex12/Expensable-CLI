# Start here. Happy coding!
require "httparty"
require "colorize"
require "terminal-table"
require "json"
require "date"
require_relative "helpers/helpers"
require_relative "services/sessions"
require_relative "services/categories"
require_relative "services/transactions"

class ExpensableApp
  include Helpers

  attr_accessor :expenses, :current_month, :categories, :transactions

  def initialize
    @user = nil
    @categories = []
    @transactions = nil
    @expenses = false
    @current_date = Date.today
    @transaction_in_details = []
  end

  def start 
    action = ""
    until action == "exit"
      begin
        puts welcome_message
        action = login_menu[0]
        case action 
        when "login" then login
        when "create_user" then create_user
        when "exit" then puts exit_message
        end
      rescue HTTParty::ResponseError => error
        parsed_error = JSON.parse(error.message, symbolize_names: true)
        puts parsed_error[:errors].join
      end
    end
  end

  def login
    credentials = credentials_form
    @user = Services::Sessions.login(credentials)
    puts "Welcome back Expensable #{@user[:first_name]} #{@user[:last_name]}"
    categories_page
  end

  def create_user
    user_data = user_data_form
    @user = Services::Sessions.signup(user_data)
    puts "Welcome to Expensable #{@user[:first_name]} #{@user[:last_name]}" if @user
    categories_page
  end

  def categories_page
    @categories = Services::Categories.index(@user[:token])

    action = ""
    until action == "logout"
      begin
        puts categories_table
        sub_loop
      return action
      rescue HTTParty::ResponseError => error
        parsed_error = JSON.parse(error.message, symbolize_names: true)
        puts parsed_error[:errors].join
      end
    end
  end

  def categories_table
    expenses = categories[:expense]
    month_to_print = []
    expenses.group_by do |c|
      if c[:transactions].empty?
        month_to_print << c
      end
      c[:transactions].find do |t|
        if Date.parse(t[:date]).strftime("%B %Y") == @current_date.strftime("%B %Y")
          month_to_print << c
        end
      end
    end

    table = Terminal::Table.new
    table.title = "Expenses\n #{@current_date.strftime("%B %Y")}".colorize(:yellow)
    table.headings = ["ID", "Category", "Total"]
    table.rows = month_to_print.map do |c|
      [c[:id], c[:name].colorize(c[:color].to_sym), (c[:transactions].map { |t| t[:amount] }.sum)]
    end

    @expenses = true
    table 
  end

  def categories_table_income
    income = categories[:income]
    month_to_print = []
    income.group_by do |c|
      if c[:transactions].empty?
        month_to_print << c
      end
      c[:transactions].find do |t|
        if Date.parse(t[:date]).strftime("%B %Y") == @current_date.strftime("%B %Y")
          month_to_print << c
        end
      end
    end

    table = Terminal::Table.new
    table.title = "Income \n #{@current_date.strftime("%B %Y")}".colorize(:cyan)
    table.headings = ["ID", "Category", "Total"]
    table.rows = month_to_print.map do |c|
      [c[:id], c[:name], (c[:transactions].map { |t| t[:amount] }.sum)]
    end

    @expenses = false
    table
  end

  def categories
    @categories.group_by do |category|
      category[:transaction_type].to_sym
    end
  end

  def create_category
    category_data = category_data_form
    new_data = Services::Categories.create(@user[:token], category_data)
    @categories << new_data
    categories_page
  end

  def update_category(id)
    category_data = category_data_form
    updated_category = Services::Categories.update(@user[:token], id, category_data)

    found_category = @categories.find { |c| c[:id] == id }
    found_category.update(updated_category)
    categories_page
  end

  def delete_category(id)
    deleted_category = Services::Categories.destroy(@user[:token], id)
    found_category = @categories.find { |c| c[:id] == id }
    @categories.delete(found_category)
    categories_page
  end

  def prev_month
    @current_date = @current_date.prev_month 
    action = ""
    until action == "logout"
      begin
        puts categories_table
        sub_loop
        return action
      rescue HTTParty::ResponseError => error
        parsed_error = JSON.parse(error.message, symbolize_names: true)
        puts parsed_error[:errors].join
      end
    end
  end

  def next_month
    @current_date = @current_date.next_month
    action = ""
    until action == "logout"
      begin
        puts categories_table
        sub_loop
        return action
      rescue HTTParty::ResponseError => error
        parsed_error = JSON.parse(error.message, symbolize_names: true)
        puts parsed_error[:errors].join
      end
    end
  end


  def toggle_category
    # @categories = Services::Categories.index(@user[:token])
    action = ""
    until action == "logout"
      begin
        table_to_print
        sub_loop
      return action
      rescue HTTParty::ResponseError => error
        parsed_error = JSON.parse(error.message, symbolize_names: true)
        puts parsed_error[:errors].join
      end
    end
  end

  def table_to_print
    if @expenses == true
      puts categories_table_income
    else
      puts categories_table
    end
  end

  def add_to_category(id)
    transaction_data = transaction_data_form
    @transactions = Services::Transactions.create(@user[:token], id, transaction_data)
    categories_page
  end

  def show_category(id)
    category = @categories.find { |c| c[:id] == id }

    show_details_page(category)

    action = ""
    until action == "back"
      begin
        show_details_loop(id)
        return action
      rescue HTTParty::ResponseError => error
        parsed_error = JSON.parse(error.message, symbolize_names: true)
        puts parsed_error[:errors].join
      end
    end
  end

  def next_details(id)
    @current_date = @current_date.next_month
    category = @categories.find { |c| c[:id] == id }
    action = ""
    until action == "back"
      begin
        show_details_page(category)
        show_details_loop(id)
        return action
      rescue HTTParty::ResponseError => error
        parsed_error = JSON.parse(error.message, symbolize_names: true)
        puts parsed_error[:errors].join
      end
    end
  end

  def prev_details(id)
    @current_date = @current_date.prev_month
    category = @categories.find { |c| c[:id] == id }
    action = ""
    until action == "back"
      begin
        show_details_page(category)
        show_details_loop(id)
        return action
      rescue HTTParty::ResponseError => error
        parsed_error = JSON.parse(error.message, symbolize_names: true)
        puts parsed_error[:errors].join
      end
    end
  end

  def show_details_page(category)
    category_to_print = []

    category_by_month = category[:transactions].group_by do |t|
      if Date.parse(t[:date]).strftime("%B %Y") == @current_date.strftime("%B %Y")
        category_to_print << t
      end
    end

    category_to_print.sort! do |a, b|
      Date.parse(a[:date]) <=> Date.parse(b[:date])
    end

    table = Terminal::Table.new
    table.title = "#{category[:name]}\n#{@current_date.strftime("%B %Y")}"
    table.headings = ["ID", "Date", "Amount", "Notes"]
    table.rows = category_to_print.map do |t|
      [t[:id], t[:date], t[:amount], t[:notes]]
    end

    puts table
  end

  def add_transaction(id)
    transaction_data = transaction_data_form
    
    @transaction_in_details = Services::Transactions.create(@user[:token], id, transaction_data)
    @categories = Services::Categories.index(@user[:token])
    category = @categories.find { |c| c[:id] == id }
    show_details_page(category)
    show_details_loop(id)
  end

  def update_transaction(c_id, t_id)
    transaction_data = transaction_data_form
    updated_transaction = Services::Transactions.update(@user[:token], c_id, t_id, transaction_data)

    found_transaction = @categories.find { |c| c[:id] == c_id }
    found_transaction.update(updated_transaction)
    @categories = Services::Categories.index(@user[:token])
    category = @categories.find { |c| c[:id] == c_id }
    show_details_page(category)
    show_details_loop(c_id)
  end

  def delete_transaction(c_id, t_id)
    deleted_transaction = Services::Transactions.destroy(@user[:token], c_id, t_id)
    found_transaction = @categories.find { |c| c[:id] == c_id }
    found_transaction.delete(deleted_transaction)
    @categories = Services::Categories.index(@user[:token])
    category = @categories.find { |c| c[:id] == c_id }
    show_details_page(category)
    show_details_loop(c_id)
  end
end

app = ExpensableApp.new
app.start