# frozen_string_literal: true

require 'tempfile'
require 'zip'

module Procreate
  module Swatches
    class Exporter
      include CallableClass

      attr_accessor :wrapper
      attr_reader :zip_path

      def initialize(wrapper, options = {})
        @wrapper = wrapper
        parse_options(options)
      end

      def call
        zip_content!

        zip_path
      end

      alias export call

      def options
        parse_options(@options)
      end

      def options=(hash)
        parse_options(hash)
      end

      private

      PERMITTED_OPTIONS = %i[export_directory file_name].freeze
      DEFAULT_OPTIONS = {
        export_directory: Dir.pwd
      }

      def parse_options(options)
        @options = DEFAULT_OPTIONS.merge(
          options.symbolize_keys.slice(*PERMITTED_OPTIONS)
        )
      end

      def create_temp_swatches_file!
        json_content = wrapper.to_json
        temp_file = Tempfile.new(wrapper.name)
        temp_file << json_content
        temp_file.rewind
        temp_file.path
      end

      def zip_content!
        temp_file = create_temp_swatches_file!

        Zip::File.open(generate_unique_filename, Zip::File::CREATE) do |zipfile|
          zipfile.add(SWATCHES_FILE_NAME, temp_file)
        end
      end

      # http://myprogrammingblog.com/2015/01/05/how-to-ensure-that-filename-is-always-unique-ruby/
      #
      # Function generates uniq file name from the String passed to it
      # based on extension and basename
      #
      # @param [String] new_file_name desired file_name
      #
      # @return [String] generated file name
      def generate_unique_filename
        name = options[:file_name] || wrapper.name

        filename = "#{name}.swatches"

        ext = File.extname(filename)
        name = File.basename(filename, ext)
        related_file_indexes = []

        file_list = Dir[Pathname.new(File.dirname(filename)).join('*.swatches')]

        file_list.select do |file|
          if File.basename(file).include?(name) && File.extname(file) == ext
            related_file_indexes << file.split('-').last.to_i
          end
        end

        filename = if related_file_indexes.present?
          name + '-' + (related_file_indexes.max + 1).to_s + ext
        else
          name + ext
        end

        @zip_path = File.join(options[:export_directory], filename)
      end
    end
  end
end
