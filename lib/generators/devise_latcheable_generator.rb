require 'rails/generators/active_record'

module DeviseLatcheable
  module Generators
    class DeviseLatcheableGenerator < ActiveRecord::Generators::Base
      namespace "devise_latcheable"
      source_root File.expand_path("../templates", __FILE__)

      def copy_devise_latcheable_migration
        migration_template "migration.rb", "db/migrate/devise_latcheable_#{table_name}.rb"
      end

      def copy_config
        template "latch.yml", "config/latch.yml"
      end

      def show_readme
        readme "README"
      end
    end
  end
end
