require './lib/user'
require './lib/admin'
require 'yaml'
require './lib/hosting'


class Domain
  attr_reader :id, :name, :price

  def initialize(id, name, price)
    @id = id
    @name = name
    @price = price
  end

  def self.from_yaml(obj)
    Domain.new(obj['id'], obj['name'], obj['price'])
  end
end
