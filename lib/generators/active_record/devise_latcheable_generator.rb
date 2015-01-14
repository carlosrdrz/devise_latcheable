# devise_latcheable: latch implementation for rails and devise
# Copyright (C) 2015 Carlos Rodriguez
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

require 'rails/generators/active_record'

module ActiveRecord
  module Generators
    class DeviseLatcheableGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)
      desc 'Creates a migration'
      class_option :orm

      def copy_devise_latcheable_migration
        migration_template "migration.rb", "db/migrate/add_devise_latcheable_to_#{table_name}.rb"
      end

      def copy_config
        template "latch.yml", "config/latch.yml"
      end
    end
  end
end
