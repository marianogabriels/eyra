require 'byebug'
require "eyra/version"

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
    self.class.fields.each { |field| json[field.name.to_s] = field.serialize(object) }
    json
  end

  module ClassMethods
    attr_accessor :fields

    def dump_format(name,opts={},&block)
      field = @fields.find{|e| e.name == name }
      field.opts[:dump_format] = block
    end

    def field(name, opts={})
      field = Field.new(name,opts)
      @fields << field
      self.class_eval do |klass|
        define_method name do
          return field.serialize(@object)
        end
      end
    end
  end



  class Field
    attr_accessor :name,:opts
    Field::Mapping = {
      "String" => lambda {|value| value.to_s },
      "Integer" => lambda{|value| value.to_i },
      "Float" => lambda{|value| value.to_f },
      "Boolean" => lambda{|value| !!(value) }
    }

    def initialize(name,opts)
      @name = name
      @opts = opts
    end

    def serialize(object)
      return value unless (opts[:type])
      serializer = Field::Mapping[opts[:type].to_s]
      opts[:dump_format] ? opts[:dump_format].call(object) : serializer.call(object.send(name))
    end
  end
end
