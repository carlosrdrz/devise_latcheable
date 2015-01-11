# devise_latcheable
This gem adds an extra layer of security using a Latch account to any Rails app using the devise gem.

You can find more info about Latch at https://latch.elevenpaths.com

## How to install and configure it

1. Install and configure devise gem. You can follow the guide at https://github.com/plataformatec/devise
2. Add the gem to your Gemfile
```ruby
gem 'devise_latcheable'
```
3. Add latcheable to the module list on your users model
```ruby
devise :database_authenticatable, :latcheable, :registerable,
       :recoverable, :rememberable, :trackable, :validatable
```
4. Run the generator with the name of the model you're using
```bash
rails generate devise_latcheable MODEL_NAME
```
5. Run rake db:migrate to update the database
6. Modify config/latch.yml file with your app id and secret codes
7. Modify your routes.rb file to change your devise_for controllers option
```ruby
devise_for :users, controllers: { registrations: 'devise_latcheable/registrations' }
```

## Using devise_latcheable

### Pair code
An attr_accessor called 'latch_pair_code' is registered on your application users model. This attribute isn't saved on your database but is needed when a user is being created. devise_latcheable will check this code against Latch. If the user pair code is valid, the user will be registered and logged in.
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
A instance attribute called 'latch_enabled' is added to your users model to specify if that instance is going to be authenticated against Latch. This attribute is set to 'true' if 'always_enabled' is set to 'true' in the config file.
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
A user is unpaired when you destroy its instance if it has latch enabled in its instance
```ruby
user = User.find_by name: 'Test'
user.destroy # Latch is unpaired at this point, and the user will receive a notification in it latch app
```

### Account id
When a user pairs with Latch, devise_latcheable needs to hold a reference to that user latch id to check their latch status. You can get a user's latch id calling latch_account_id on it.
```
user = User.find_by name: 'Test'
user.latch_account_id
```

## Demo
There is a app already configured with devise and devise_latcheable at https://github.com/CarlosRdrz/latch_app for demo and development purposes.
