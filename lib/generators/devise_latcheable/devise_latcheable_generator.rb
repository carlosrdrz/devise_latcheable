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
