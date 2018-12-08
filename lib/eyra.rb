require 'byebug'
require 'eyra/version'

module Eyra
  def self.included(base)
    base.extend ClassMethods
    base.fields = []
  end

  attr_reader :object
  attr_accessor :fields

  def initialize(object)
    @object = object
  end

  def as_json
    json = {}
    self.class.fields.each do |field|
      json[field.name.to_s] = field.serialize(object)
    end
    json
  end

  module ClassMethods
    attr_accessor :fields

    def dump_format(name, _opts = {}, &block)
      field = @fields.find { |e| e.name == name }
      field.opts[:dump_format] = block
    end

    def field(name, opts = {})
      field = Field.new(name, opts)
      @fields << field
      class_eval do |_klass|
        define_method name do
          return field.serialize(@object)
        end
      end
    end
  end

  class Field
    attr_accessor :name, :opts
    MAPPING = {
      String: ->(value) { value.to_s },
      Integer: ->(value) { value.to_i },
      Float: ->(value) { value.to_f },
      Boolean: ->(value) { !value.nil? }
    }.freeze

    def initialize(name, opts)
      @name = name
      @opts = opts
    end

    def serialize(object)
      return value unless opts[:type]

      serializer = Field::MAPPING[opts[:type].to_s.to_sym]
      if opts[:dump_format]
        opts[:dump_format].call(object)
      else
        serializer.call(object.send(name))
      end
    end
  end
end
