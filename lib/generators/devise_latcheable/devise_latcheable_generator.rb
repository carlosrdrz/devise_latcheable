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

require 'rails/generators/named_base'

module DeviseLatcheable
  module Generators
    class DeviseLatcheableGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../../templates", __FILE__)
      namespace "devise_latcheable"

      hook_for :orm

      def show_readme
        readme "README"
      end
    end
  end
end
