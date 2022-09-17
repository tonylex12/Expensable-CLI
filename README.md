# Expensable CLI

Taking control over your personal finance is an important skill to develop. In
today's reality, don't have any debt is the holy grail of many grown-ups. That's
why so many expenses-tracker apps exist in the market. Here comes `Expensable`
🎉

Expensable is an expense/income tracker app that exposes an API to allow the
developer to freely build their own interfaces to interact with the app data.
Every `user` has their own account protected by email and password. Expensable
API gives you an authorization token to validate every request after creating a
new user o login back to the application. Each `user` has many expense/income
`categories`, and each category has many `transactions`. You can perform `CRUD`
operations over your categories and transactions.

Your team has the job to develop a Command-Line expense/tracker application
using the Expensable API. Here is the list of the application features:

### Start the program

When started, your program should display the welcome message and main menu.

```
$ ruby expensable.rb
####################################
#       Welcome to Expensable      #
####################################
login | create_user | exit
>
```

- When an invalid option is typed the error message is: `"Invalid option"`

```
####################################
#       Welcome to Expensable      #
####################################
login | create_user | exit
> something
Invalid option
> 
```

### Create a user

When the option `create_user` is typed, your program should ask for the user
data. Then it should create the user making a post request to the API with the
user data. If the response is successful, the program should display
`"Welcome to Expensable [first_name] [last_name]"` followed by the categories
page. The categories page display a table with all the categories of the type
`expense` show the transactions of the current month, and the categories menu
(later you can toggle this to see the income categories). A newly created user
doesn't have any categories yet, that's why the table is empty.

```
> create_user
Email: john@mail.com
Password: 123456
First name: John
Last name: Doe
Phone: 987654321
Welcome to Expensable John Doe
+----+----------+-------+
|       Expenses        |
|     December 2021     |
+----+----------+-------+
| ID | Category | Total |
+----+----------+-------+
+----+----------+-------+
create | show ID | update ID | delete ID
add-to ID | toggle | next | prev | logout
>
```

- `email`: Required. Email format. Error message `"Invalid format"`
- `password`: Required. Minimum length 6. Error message `"Minimum 6 characters"`
- `first_name`: optional `last_name`: optional `phone`: optional. If supplied it
  should match `987654321` or `+51 987654321`. Error message:
  `"Required format: +51 111222333 or 111222333"`

### Logout

Typing logout should perform the logout request to the API and return to the
main page.

```
> logout
####################################
#       Welcome to Expensable      #
####################################
login | create_user | exit
>
```

### Login (and show categories page)

If you have created a user previously, you can log in by typing the option
`login`. The program should ask for the login data (username and password) and
then make the login request to the API. If the response is successful, the
program should display `"Welcome back [first_name] [last_name]"` followed by the
categories page.

- Every student has a test user to experiment with.
- username: `test[number]@mail.com`
- password: `123456`

We will use the user `test0@mail.com` from now on. This user has already some
categories and transactions. To populate the categories table, your program
should make a get request to the API asking for all the categories and store the
response on an internal variable.

In this case, the has 6 categories of type expense. For December 2021, the sum
of all the transactions amounts (values) is displayed on the Total column. This
should be calculated by your program since the API doesn't store this value.

```
> login
Email: test0@mail.com
Password: 123456
Welcome back Test User
+----+----------------+-------+
|          Expenses           |
|        December 2021        |
+----+----------------+-------+
| ID | Category       | Total |
+----+----------------+-------+
| 3  | Food           | 206   |
| 4  | Transportation | 72    |
| 5  | Utilities      | 30    |
| 6  | Education      | 520   |
| 7  | Entertainment  | 25    |
| 8  | Other          | 220   |
+----+----------------+-------+
create | show ID | update ID | delete ID
add-to ID | toggle | next | prev | logout
>
```

- `email`: Required. Error message `"Cannot be blank"`
- `password`: Required. Error message `"Cannot be blank"`
- If the API response is not successful, use the response body message:
  `"Incorrect email or password"`

```
> login
Email: wrong@mail.com
Password: wrongpassword
Incorrect email or password
####################################
#       Welcome to Expensable      #
####################################
login | create_user | exit
>
```

### Create category

When the option `create` is typed, the program asks for the category data (name
and transaction_type). With that, it creates the category making a post request
to the API. If the response is successful, the program will add the newly
created category to the internal variable and display the table again. The new
category should appear with 0 on the total column since it doesn't have any
transactions yet.

```
> create
Name: New Category
Transaction type: expense
+-----+----------------+-------+
|           Expenses           |
|        November 2020         |
+-----+----------------+-------+
| ID  | Category       | Total |
+-----+----------------+-------+
| 3   | Food           | 206   |
| 4   | Transportation | 72    |
| 5   | Utilities      | 30    |
| 6   | Education      | 520   |
| 7   | Entertainment  | 25    |
| 8   | Other          | 220   |
| 113 | New Category   | 0     |
+-----+----------------+-------+
create | show ID | update ID | delete ID
add-to ID | toggle | next | prev | logout
>
```

- `name`: Required. Error message `"Cannot be blank"`
- `transaction_type`: Required. Only "expense" or "income". Error message
  `"Only income or expense"`

### Update Category

The user can update a category by typing `update [Category ID]`. The program
will ask for the new data and make a patch request to the API. If everything
goes fine, the program should update its internal record and display the table
showing the updated information.

```
> update 113
Name: New Expense
Transaction type: expense
+-----+----------------+-------+
|           Expenses           |
|        November 2020         |
+-----+----------------+-------+
| ID  | Category       | Total |
+-----+----------------+-------+
| 3   | Food           | 206   |
| 4   | Transportation | 72    |
| 5   | Utilities      | 30    |
| 6   | Education      | 520   |
| 7   | Entertainment  | 25    |
| 8   | Other          | 220   |
| 113 | New Expense    | 0     |
+-----+----------------+-------+
create | show ID | update ID | delete ID
add-to ID | toggle | next | prev | logout
>
```

- `name`: Required. Error message `"Cannot be blank"`
- `transaction_type`: Required. Only "expense" or "income". Error message
  `"Only income or expense"`

### Delete Category

When the option `delete [Category ID]` is typed with a valid category ID, the
program will make a delete request to the API using the ID. If the response is
successful, it will remove the record from the internal variable and display the
table again.

```
> delete 113
+----+----------------+-------+
|          Expenses           |
|        November 2020        |
+----+----------------+-------+
| ID | Category       | Total |
+----+----------------+-------+
| 3  | Food           | 206   |
| 4  | Transportation | 72    |
| 5  | Utilities      | 30    |
| 6  | Education      | 520   |
| 7  | Entertainment  | 25    |
| 8  | Other          | 220   |
+----+----------------+-------+
create | show ID | update ID | delete ID
add-to ID | toggle | next | prev | logout

```

- If no ID or an invalid ID is provided, the error message should be:
  `"Not Found"`

### Toggle (between expenses and income)

With the option toggle, your program should change the transaction types back
and forth between Expense and Income. It could have some type of flag variable
to keep track of which transactions to show at any time.

```
> toggle
+----+-------------+-------+
|          Income          |
|      December 2020       |
+----+-------------+-------+
| ID | Category    | Total |
+----+-------------+-------+
| 1  | Salary      | 0     |
| 2  | Independent | 800   |
+----+-------------+-------+
create | show ID | update ID | delete ID
add-to ID | toggle | next | prev | logout
> 
```

### Prev and Next (previous and next month)

The `prev` and `next` option allows the user to navigate through the calendar
months. The program could have another flag variable to keep track of which
month it should display at any time. (by default that variable should be
initialize with the current month)

```
> prev
+----+-------------+-------+
|          Income          |
|       November 2021      |
+----+-------------+-------+
| ID | Category    | Total |
+----+-------------+-------+
| 1  | Salary      | 2600  |
| 2  | Independent | 600   |
+----+-------------+-------+
create | show ID | update ID | delete ID
add-to ID | toggle | next | prev | logout
> next
+----+-------------+-------+
|          Income          |
|      December 2021       |
+----+-------------+-------+
| ID | Category    | Total |
+----+-------------+-------+
| 1  | Salary      | 0     |
| 2  | Independent | 800   |
+----+-------------+-------+
create | show ID | update ID | delete ID
add-to ID | toggle | next | prev | logout
> toggle
+----+----------------+-------+
|          Expenses           |
|        December 2021        |
+----+----------------+-------+
| ID | Category       | Total |
+----+----------------+-------+
| 3  | Food           | 206   |
| 4  | Transportation | 72    |
| 5  | Utilities      | 30    |
| 6  | Education      | 520   |
| 7  | Entertainment  | 25    |
| 8  | Other          | 220   |
+----+----------------+-------+
create | show ID | update ID | delete ID
add-to ID | toggle | next | prev | logout
>
```

### Add-to (add transaction to a category)

The application allows adding a new transaction directly from the categories
page with the option `add-to [Category ID]`. It will ask for the transaction
data and make a post request to the API. Notice that you need to use a nested
URL like `/categories/[category_id]/transactions`. Check on Insomnia if you have
any doubts. If the response is successful, the program will add the transaction
to the corresponding category and display the table again. The total column for
that category should be updated.

```
> add-to 4
Amount: 5
Date: 2021-12-23
Notes: Visit a friend
+----+----------------+-------+
|          Expenses           |
|        December 2021        |
+----+----------------+-------+
| ID | Category       | Total |
+----+----------------+-------+
| 3  | Food           | 206   |
| 4  | Transportation | 77    |
| 5  | Utilities      | 30    |
| 6  | Education      | 520   |
| 7  | Entertainment  | 25    |
| 8  | Other          | 220   |
+----+----------------+-------+
create | show ID | update ID | delete ID
add-to ID | toggle | next | prev | logout
>
```

- `amount`: Positive integer. Error message `"Cannot be zero"`
- `date`: Required. Should have the format YYYY-MM-DD. Error message
  `"Required format: YYYY-MM-DD"`
- `notes`: optional

### Show a category (show details)

The user can type `show [Category ID]` to see the transactions page with the
list of transactions for that category. The menu on this page is different as
well. The Date column should display the transaction date with the format shown
below.

```
> show 4
+-----+-------------+--------+-----------------+
|                Transportation                |
|                December 2021                 |
+-----+-------------+--------+-----------------+
| ID  | Date        | Amount | Notes           |
+-----+-------------+--------+-----------------+
| 50  | Wed, Dec 1  | 15     | Taxis           |
| 51  | Sat, Dec 4  | 4      | Public          |
| 52  | Wed, Dec 8  | 13     | Taxis           |
| 53  | Fri, Dec 10 | 3      | Public          |
| 54  | Wed, Dec 15 | 14     | Taxis           |
| 55  | Mon, Dec 20 | 3      | Public          |
| 56  | Wed, Dec 22 | 15     | Taxis           |
| 995 | Wed, Dec 23 | 5      | Visit a friend  |
| 57  | Fri, Dec 24 | 5      | Public          |
+-----+-------------+--------+-----------------+
add | update ID | delete ID
next | prev | back
>
```

### Add transaction

The option `add` creates a new transaction for the current category. Since the
category_id is not provided by the user, your program should keep track of which
is the current category that is being displayed to use that id on the API
request.

```
> add
Amount: 9
Date: 2021-12-19 
Notes: More taxis
+-----+-------------+--------+-----------------+
|                Transportation                |
|                December 2021                 |
+-----+-------------+--------+-----------------+
| ID  | Date        | Amount | Notes           |
+-----+-------------+--------+-----------------+
| 50  | Wed, Dec 1  | 15     | Taxis           |
| 51  | Sat, Dec 4  | 4      | Public          |
| 52  | Wed, Dec 8  | 13     | Taxis           |
| 53  | Fri, Dec 10 | 3      | Public          |
| 54  | Wed, Dec 15 | 14     | Taxis           |
| 996 | Sun, Dec 19 | 9      | More taxis      |
| 55  | Mon, Dec 20 | 3      | Public          |
| 56  | Wed, Dec 22 | 15     | Taxis           |
| 995 | Wed, Dec 23 | 5      | Visit a friend  |
| 57  | Fri, Dec 24 | 5      | Public          |
+-----+-------------+--------+-----------------+
add | update ID | delete ID
next | prev | back
>
```

- Validations same as Add-to

### Update transaction

If the user types `update [transaction ID]` with a valid id, the program will
ask for the new transaction data and make a patch request to the API. Same as
before, it needs the current category id to perform this operation.

```
> update 995
Amount: 7
Date: 2021-12-22
Notes: Updated expense
+-----+-------------+--------+-----------------+
|                Transportation                |
|                December 2021                 |
+-----+-------------+--------+-----------------+
| ID  | Date        | Amount | Notes           |
+-----+-------------+--------+-----------------+
| 50  | Wed, Dec 1  | 15     | Taxis           |
| 51  | Sat, Dec 4  | 4      | Public          |
| 52  | Wed, Dec 8  | 13     | Taxis           |
| 53  | Fri, Dec 10 | 3      | Public          |
| 54  | Wed, Dec 15 | 14     | Taxis           |
| 996 | Sun, Dec 19 | 9      | More taxis      |
| 55  | Mon, Dec 20 | 3      | Public          |
| 56  | Wed, Dec 22 | 15     | Taxis           |
| 995 | Wed, Dec 22 | 7      | Updated expense |
| 57  | Fri, Dec 24 | 5      | Public          |
+-----+-------------+--------+-----------------+
add | update ID | delete ID
next | prev | back
>
```

- `amount` and `date` required as in add transaction. `notes` is optional.
- If notes is left blank it shouldn't update the transaction notes attribute.∫

### Delete transaction

If the user type `delete [transaction ID]` with a valid id, the program will aa
delete request to the API. Same as before, it needs the current category id to
perform this operation.

```
> delete 995
+-----+-------------+--------+-----------------+
|                Transportation                |
|                December 2021                 |
+-----+-------------+--------+-----------------+
| ID  | Date        | Amount | Notes           |
+-----+-------------+--------+-----------------+
| 50  | Wed, Dec 1  | 15     | Taxis           |
| 51  | Sat, Dec 4  | 4      | Public          |
| 52  | Wed, Dec 8  | 13     | Taxis           |
| 53  | Fri, Dec 10 | 3      | Public          |
| 54  | Wed, Dec 15 | 14     | Taxis           |
| 996 | Sun, Dec 19 | 9      | More taxis      |
| 55  | Mon, Dec 20 | 3      | Public          |
| 56  | Wed, Dec 22 | 15     | Taxis           |
| 57  | Fri, Dec 24 | 5      | Public          |
+-----+-------------+--------+-----------------+
add | update ID | delete ID
next | prev | back
>
```

### Prev and Next (same as in categories page)

The `prev` and `next` options still works exactly as before. The program should
just re-use the same methods as before.

```
> prev
+----+-------------+--------+--------+
|           Transportation           |
|            November 2021           |
+----+-------------+--------+--------+
| ID | Date        | Amount | Notes  |
+----+-------------+--------+--------+
| 42 | Thu, Nov 4  | 15     | Taxis  |
| 43 | Mon, Nov 8  | 4      | Public |
| 44 | Thu, Nov 11 | 12     | Taxis  |
| 45 | Mon, Nov 15 | 2      | Public |
| 46 | Thu, Nov 18 | 11     | Taxis  |
| 47 | Mon, Nov 22 | 3      | Public |
| 48 | Thu, Nov 25 | 12     | Taxis  |
| 49 | Sat, Nov 27 | 4      | Public |
+----+-------------+--------+--------+
add | update ID | delete ID
next | prev | back
> next
+-----+-------------+--------+-----------------+
|                Transportation                |
|                December 2021                 |
+-----+-------------+--------+-----------------+
| ID  | Date        | Amount | Notes           |
+-----+-------------+--------+-----------------+
| 50  | Wed, Dec 1  | 15     | Taxis           |
| 51  | Sat, Dec 4  | 4      | Public          |
| 52  | Wed, Dec 8  | 13     | Taxis           |
| 53  | Fri, Dec 10 | 3      | Public          |
| 54  | Wed, Dec 15 | 14     | Taxis           |
| 996 | Sun, Dec 19 | 9      | More taxis      |
| 55  | Mon, Dec 20 | 3      | Public          |
| 56  | Wed, Dec 22 | 15     | Taxis           |
| 57  | Fri, Dec 24 | 5      | Public          |
+-----+-------------+--------+-----------------+
add | update ID | delete ID
next | prev | back
>
```

### Back

The `back` option sends the user to the categories page.

```
> back
+----+----------------+-------+
|          Expenses           |
|        December 2021        |
+----+----------------+-------+
| ID | Category       | Total |
+----+----------------+-------+
| 3  | Food           | 206   |
| 4  | Transportation | 81    |
| 5  | Utilities      | 30    |
| 6  | Education      | 520   |
| 7  | Entertainment  | 25    |
| 8  | Other          | 220   |
+----+----------------+-------+
create | show ID | update ID | delete ID
add-to ID | toggle | next | prev | logout
>
```

### Exit

To exit the program, just type logout and then exit. The program shows an exit
message.

```
> logout
####################################
#       Welcome to Expensable      #
####################################
login | create_user | exit
> exit
####################################
#    Thanks for using Expensable   #
####################################
```

## Testing

Your program should implement at least 2 tests. You can choose what to test. We
recommend to test methods that return some value over methods that print stuff
to the terminal (you can explore this option but is a little more difficult).
