# frozen_string_literal: true

#
# This model will add all key/values of args hash as instance attributes
# with respective getter methods. (just for fun!!)
#
class DynamicModel
  def initialize(args)
    args.map(&init_attributes)
    args.map(&create_acessors)
  end

  def init_attributes
    lambda do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def create_acessors
    lambda do |key, _|
      define_singleton_method(key) { instance_variable_get("@#{key}") }
    end
  end
end
