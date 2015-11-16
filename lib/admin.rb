require './lib/user'
require 'json'
require 'yaml'
require './lib/hosting'

# Nikodemas Zaliauskas INFO 3 kursas Hostingo paslaugu servisas
class Admin
  attr_reader :id, :name, :password,
              :status

  def initialize(id, name, password, status)
    @id = id
    @name = name
    @password = password
    @status = status
  end

  def self.from_yaml(obj)
    Admin.new(obj['id'], obj['name'], obj['password'], obj['status'])
  end
end
