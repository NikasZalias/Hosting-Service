require './lib/user'
require './lib/admin'
require 'yaml'
require './lib/hosting'


class Server
  attr_reader :id, :name, :price

  def initialize(id, name, price)
    @id = id
    @name = name
    @price = price
  end

  def self.from_yaml(obj)
    Server.new(obj['id'], obj['name'], obj['price'])
  end
end
