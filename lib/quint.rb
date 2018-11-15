require 'quint/essential'

module Quint
  def self.enable!
    self.instance_variable_set(:@__type_check_mode__, :error)
  end

  def self.warn!
    self.instance_variable_set(:@__type_check_mode__, :warn)
  end

  def self.disable!
    self.instance_variable_set(:@__type_check_mode__, :none)
  end

  def self.enabled?
    self.instance_variable_defined?(:@__type_check_mode__) && mode != :none
  end

  def self.mode
    self.instance_variable_get(:@__type_check_mode__)
  end

  def self.included(origin)
    origin.extend(Quint::Essential)
  end
end
