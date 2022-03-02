# frozen_string_literal: true

require 'yaml'
require 'secure_yaml'
require_relative 'patch/secure_yaml/cipher'
require 'singleton'
require 'ostruct'
require 'erb'

# App::Configuration class helps loading configuration files.
#
# In order to load config files, you need to provide encryption password to the environment
#
# To encrypt content, use the following command:
#
# encrypt_property_for_yaml encrypt [SECRET_PASSWORD] [CONTENT_TO_ENCRYPT]
module App
  # Configuratior namespace
  class Configurator
    # OpenStruct class adaptation
    class Struct < OpenStruct
      alias each each_pair

      # convert struct to hash, taken from:
      # https://github.com/rubyconfig/config
      def to_hash
        result = {}
        marshal_dump.each do |k, v|
          if v.instance_of? Configurator::Struct
            result[k] = v.to_hash
          elsif v.instance_of? Array
            result[k] = descend_array(v)
          else
            result[k] = v
          end
        end
        result
      end

      private

      def descend_array(array)
        array.map do |value|
          if value.instance_of? Configurator::Struct
            value.to_hash
          elsif value.instance_of? Array
            descend_array(value)
          else
            value
          end
        end
      end
    end

    FILES_EXTENSION = 'yaml'
    DEFAULT_ENVIRONMENT = 'production'
    attr_accessor :environment,
                  :files_path

    def initialize
      @environment = DEFAULT_ENVIRONMENT
    end

    def load_all!
      files = Dir.glob("#{files_path}/*.#{FILES_EXTENSION}")
      names = files.map { |f| File.basename(f).split(".").first }.uniq

      names.each { |name| load!(name) }
    end

    # options allowed:
    #
    # environment: 'production'
    # filter: 'filter character'
    def load!(name, filter: nil )
      filename = config_filename(name)
      generate_attr_reader(name, load_formatted_data(filename, filter))
    end

    def global_name=(name)
      Object.send(:remove_const, name) if Object.const_defined?(name)
      Object.const_set(name, App.config)
    end

    private

    def load_formatted_data(filename, filter)
      hash_data = load_from_yaml(filename)
      formatted_data(hash_data, filter: filter, struct: true)
    end

    def config_filename(name)
      filename = "#{name}.yaml"
      filename_with_env = filename.gsub(FILES_EXTENSION, "#{environment}.#{FILES_EXTENSION}")

      found_file = get_file_that_exists([filename, filename_with_env])
      return found_file unless found_file.nil?

      raise "Configuration file '#{filename}' or '#{filename_with_env}' doesn't exist on path '#{files_path}'"
    end

    def formatted_data(data, filter:, struct:)
      data = filtered_data(data, filter)
      struct ? convert_to_struct(data) : data
    end

    def filtered_data(data, filter)
      filter.nil? ? data : data[filter]
    end

    def get_file_that_exists(filenames)
      found_file = nil

      filenames.each do |filename|
        found_file = filename if file_exists?(file_full_path(filename))
        break if found_file
      end

      found_file
    end

    def file_exists?(path)
      File.exist? path
    end

    def file_full_path(filename)
      "#{files_path}/#{filename}"
    end

    def load_from_yaml(filename)
      yaml_file = ERB.new(File.read(file_full_path(filename))).result
      SecureYaml.load(yaml_file)
    end

    # generate accessors for loaded data
    # accessors will return objects which are deep copy of themselves
    def generate_attr_reader(name, data)
      define_singleton_method(name) do
        Marshal.load(Marshal.dump(data))
      end

      send(name)
    end

    def convert_to_struct(object)
      case object
      when Hash
        object.each { |key, value| object[key] = convert_to_struct(value) }
        Configurator::Struct.new(object)
      when Array
        object.map!(&method(:convert_to_struct))
      else
        object
      end
    end
  end

  def self.config
    @config ||= Configurator.new
  end

  def self.clear_config
    @config = Configurator.new
  end
end
