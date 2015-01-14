# devise\_latcheable
This gem adds an extra security layer using a Latch account to any Rails app 
using the devise gem.

In order to use this gem, you need to know how to develop simple apps using
rails and devise.

Devise is a gem that handles user registration and sign-in for you, so you can
forget about that and focus in building great web apps.

devise_latcheable just adds Latch to devise. Doing this, Latch can be used
when logging in and registering users.

# How to install and configure it

This section supposes that you already have a web app build with rails and
using devise. To add devise_latcheable you just must follow these six steps.

1. Add the gem to your Gemfile and run 'bundle install'. 
This will install the gem and the associated dependencies.

```ruby
gem 'devise_latcheable'
```

2. Add latcheable to the module list on your users model. This list describes
the logging chain that devises must follow in order to log in an user. In the
example provided, we use `:database_authenticable` and `:latcheable` so the
user will be checked against our database and against latch.

```ruby
class User < ActiveRecord::Base
  devise :database_authenticatable, :latcheable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
```

3. Run the generator in your console with the name of the model you're using.
That will generate a new migration and will copy the main configuration file.

```bash
rails generate devise_latcheable MODEL_NAME
```

4. Run rake db:migrate to apply the new migration

5. Modify config/latch.yml file with your app id and secret codes

6. Modify your routes.rb file to change your devise\_for controllers option.
This will overwrite devise's controller and views in order to add a field on the
sign up form called 'pair code'. The user must fill that field with the code
that the Latch app provided in order to pair the user with Latch

```ruby
devise_for :users, controllers: { registrations: 'devise_latcheable/registrations' }
```

# Using devise\_latcheable
The good thing about devise\_latcheable is that you can just forget about Latch, 
because the gem will take care of it for you. If you know how to use devise, you
already know how to use devise\_latcheable!

For more advanced users, the information below will be useful in case of
modifying or expanding the functionality of devise\_latcheable.

## Custom register forms and pair code
devise\_latcheable comes with a register form for your users. To use it, you 
just need to declare the use of the registrations controller that comes with
the gem as explained in step six of 'how to install and configure it'.

You can use your custom controller and your custom views if you want, just go 
ahead to the 'Configuring views' or 'Configuring controllers' section of 
devise's readme. You just need to remember that you need a pair 
code to register the user and authenticate it with Latch.

An attr\_accessor called 'latch\_pair\_code' is registered on your application
users model to take care of that. This attribute isn't saved on your database
but is needed when a user is being created. devise\_latcheable will check this 
code against Latch. If the user pair code is valid, the user will be registered 
and logged in in your rails app.
```ruby
# Example saving an user and pairing it
user = User.new
user.email = 'crresse@gmail.com'
user.password = '123123123'
user.password_confirmation = '123123123'
user.latch_pair_code = 'fw2kW5L'
user.save # true if no errors
```

## Pairing
This gem registers a before_create callback to pair the user with the latch
server. When a user object is saved for the first time, the instance variable
'latch\_pair\_code' is used to pair the user with latch. If the code is correct,
then the user will be created, and the latch account id associated with that
user will be saved.

## Account id
When a user pairs with Latch, devise\_latcheable needs to hold a reference to
the user's latch id to check his latch status. You can get a user's latch id
calling latch\_account\_id on it.
```ruby
user = User.find_by name: 'Test'
user.latch_account_id
```

## Unpairing
devise_latcheable registers a before_destroy callback in order to unpair the
user from latch when you destroy the user instance if it has latch 
enabled on it. When you do so, the user's latch app notifies him that the app is
now unpaired from latch.
```ruby
user = User.find_by name: 'Test'
user.destroy # Latch is unpaired at this point, and the user will receive a notification in it latch app
```

## Using latch optionally
A instance attribute called 'latch\_enabled' is added to your users model to 
specify if that instance is going to be authenticated against Latch. This 
attribute is set to 'true' when you instantiate a user object if
'always\_enabled' is set to 'true' in the config file.

If you set it to a value different from 'true', devise will forget about
Latch, and will authenticate and validate the user using the remaining 
modules that you declared on your model.

A good idea would be to declare 'always\_enabled' as false on the config, and 
let the user decide if he wants to use latch auth or not. To do that, you only
need to modify the 'latch\_enabled' attributed based on what the user decided.
```ruby
# Suppose that 'always_enabled' is set to true
user = User.new
user.email = 'crresse@gmail.com'
user.password = '123123123'
user.password_confirmation = '123123123'
user.latch_enabled = false
user.save # Latch wont be checked here, since we specified that we dont want it enabled
```

## Methods on the users model

### latch_pair!
This method pairs an user with the server. If an error occurs, it copies the
error at errors base so you can access it with model_instance.errors

On success, it sets latch_account_id to the value that the latch server sent
on its response

### latch_unpair!
Removes the pairing from latch. If an error occurs, it copies the error at
errors base so you can access it with model_instance.errors.

### latch_unlocked?
Checks if the app lock is open. Returns true if the latch is unlocked and
false if the latch is locked or if there was an error

# Demo
There is a app already configured with devise and devise\_latcheable at
[this repo](https://github.com/carlosrdrz/latch_app) for demo and
development purposes.

You can see that app running at http://latcheable.carlosrdrz.es too.