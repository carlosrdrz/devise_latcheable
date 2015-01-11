# devise\_latcheable
This gem adds an extra security layer using a Latch account to any Rails app using the devise gem.

You can find more info about Latch at https://latch.elevenpaths.com

## How to install and configure it

1. Install and configure devise gem. You can follow the guide at https://github.com/plataformatec/devise

2. Add the gem to your Gemfile
```ruby
gem 'devise_latcheable'
```

3. Add latcheable to the module list on your users model
```ruby
class User < ActiveRecord::Base
  devise :database_authenticatable, :latcheable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
```

4. Run the generator in your console with the name of the model you're using.
That will generate a new migration and will copy the main configuration file.
```bash
rails generate devise_latcheable MODEL_NAME
```

5. Run rake db:migrate to apply the new migration

6. Modify config/latch.yml file with your app id and secret codes

7. Modify your routes.rb file to change your devise\_for controllers option
```ruby
devise_for :users, controllers: { registrations: 'devise_latcheable/registrations' }
```

## Using devise\_latcheable
The good thing about devise\_latcheable is that you can just forget about Latch, 
because the gem will take care of it for you. If you know how to use devise, you
already know how to use devise\_latcheable!

For more advanced users, the information below will be useful in case of modifying
or expanding the functionality of devise\_latcheable.

### Custom register forms and pair code
devise\_latcheable comes with a register form for your users. To use it, you 
just need to declare the use of the registrations controller that comes with
the gem as explained in step seven of 'how to install and configure it'.

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

### Using latch optionally
A instance attribute called 'latch\_enabled' is added to your users model to 
specify if that instance is going to be authenticated against Latch. This 
attribute is set to 'true' if 'always\_enabled' is set to 'true' in the config 
file.

If you set it to a value different from 'true', devise will forget about
Latch, and will authenticate and validate the user using the remaining 
modules that you declared on your model.
```ruby
# Suppose that 'always_enabled' is set to true
user = User.new
user.email = 'crresse@gmail.com'
user.password = '123123123'
user.password_confirmation = '123123123'
user.latch_enabled = false
user.save # Latch wont be checked here, since we specified that we dont want it enabled
```

### Unpairing
A user is unpaired from Latch when you destroy the user instance if it has latch 
enabled on it. When you do so, the user's latch app notifies him that the app is
now unpaired from latch.
```ruby
user = User.find_by name: 'Test'
user.destroy # Latch is unpaired at this point, and the user will receive a notification in it latch app
```

### Account id
When a user pairs with Latch, devise\_latcheable needs to hold a reference to
the user's latch id to check his latch status. You can get a user's latch id
calling latch\_account\_id on it.
```
user = User.find_by name: 'Test'
user.latch_account_id
```

## Demo
There is a app already configured with devise and devise\_latcheable at
[this repo](https://github.com/CarlosRdrz/latch_app) for demo and
development purposes.
