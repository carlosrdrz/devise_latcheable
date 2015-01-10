require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    class DeviseLatcheableGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)
      desc 'Creates a migration'
      class_option :orm

      def copy_devise_latcheable_migration
        migration_template "migration.rb", "db/migrate/devise_latcheable_#{table_name}.rb"
      end

      def copy_config
        template "latch.yml", "config/latch.yml"
      end
    end
  end
end
