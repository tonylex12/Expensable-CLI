module  Helpers
  def welcome_message
    puts "#{"#" * 36}".colorize(:green)
    puts "#       Welcome to Expensable      #".colorize(:green)
    puts "#{"#" * 36}".colorize(:green)
  end
  
  def login_menu
    get_with_options(["login", "create_user", "exit"])
  end

  def get_with_options(options, required: true, default: nil)
    action = ""
    id = nil
    loop do
      puts options.join(" | ")
      print "> "
      action, id = gets.chomp.split 
      action ||= ""
    
      break if options.include?(action) || (action.empty? && !required)
  
      puts "Invalid option"
    end
  
    action.empty? && default ? [default, id] : [action, id.to_i]
  end

  def credentials_form
    email = get_string("Email", required: true)
    password = get_string("Password", required: true)
    { email: email, password: password }
  end

  def user_data_form
    email = get_string("Email", required: true)
    password = get_string("Password", required: true)
    first_name = get_string("First name")
    last_name = get_string("Last name")
    phone = get_string("Phone")
    
    if phone.empty?
      { 
        email: email,
        password: password,
        first_name: first_name,
        last_name: last_name
      } 
    else
      { 
        email: email,
        password: password,
        first_name: first_name,
        last_name: last_name,
        phone: phone
      } 
    end
  end

  def category_data_form
    name = get_string("Name", required: true)
    transaction_type = get_string("Transaction type", required: true)
    color = get_string("Color (red, orange, yellow, green, teal, cyan, light-blue or blue)", required: true)
    icon = get_string("Icon (bank, cart, health, game, bill, education, car or gift)", required: true)
    { 
      name: name, 
      transaction_type: transaction_type, 
      color: color, 
      icon: icon
    }
  end

  def transaction_data_form
    amount = get_string("Amount", required: true)
    notes = get_string("Notes")
    date = get_string("Date", required: true)
    { amount: amount.to_i, notes: notes, date: date }
  end


  def get_string(label, required: false)
    input = ""
    loop do
      print "#{label}: "
      input = gets.chomp
      break unless input.empty? && required

      puts "Cannot be blank"
    end
    input
  end

  def categories_menu(first_options, second_options)
    print first_options.join(" | ")
    puts ""
    print second_options.join(" | ")
    puts ""
    print "> "
    action, id = gets.chomp.split
    [action, id.to_i]
  end

  def sub_loop
    action, id = categories_menu(
      ["create", "show ID", "update ID", "delete ID"],
      ["add-to ID", "toggle", "next", "prev", "logout"]
    )
    case action
    when "create" then create_category
    when "show" then show_category(id)
    when "update" then update_category(id)
    when "delete" then delete_category(id)
    when "add-to" then add_to_category(id)
    when "toggle" then toggle_category
    when "next" then next_month
    when "prev" then prev_month
    end
  end

  def show_details_loop(id)
    id_to_into = id
    action, id = categories_menu(
      ["add", "update ID", "delete ID"],
      ["next", "prev", "back"]
    )
    case action
    when "add" then add_transaction(id_to_into)
    when "update" then update_transaction(id_to_into, id)
    when "delete" then delete_transaction(id_to_into, id)
    when "next" then next_details(id_to_into)
    when "prev" then prev_details(id_to_into)
    when "back" then categories_page
    end
  end

  def exit_message
    print "#{"#" * 36}\n".colorize(:red)
    print "#    Thanks for using Expensable   #\n".colorize(:red)
    print "#{"#" * 36}\n".colorize(:red)
  end
end