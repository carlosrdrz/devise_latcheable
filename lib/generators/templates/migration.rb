class AddDeviseLatcheableTo<%= table_name.camelize %> < ActiveRecord::Migration
  def change
    add_column :<%= table_name %>, :latch_account_id, :string
    add_column :<%= table_name %>, :latch_enabled, :boolean
  end
end