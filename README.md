# devise_latcheable
This gem adds an extra layer of security using a Latch account.

You can find more info about Latch at https://latch.elevenpaths.com

## How to use it

1. Install and configure devise gem. You can follow the guide at https://github.com/plataformatec/devise

2. Add the gem to your Gemfile
```ruby
gem 'devise_latcheable'
```

3. Run the generator with the name of the model you're using
```bash
rails generate devise_latcheable MODEL_NAME
```

4. Run rake db:migrate to update the database

5. Modify config/latch.yml file with your app id and secret codes

6. If you want to use a default view for the register form, modify your routes.rb file and your devise_for controllers option
```ruby
devise_for :users, controllers: { registrations: 'devise_latcheable/registrations' }
```
