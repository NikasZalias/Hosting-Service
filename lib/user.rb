require 'yaml'
require 'json'

# Nikodemas Zaliauskas INFO 3 kursas Hostingo paslaugu servisas
class User
  attr_accessor :name, :surname,
                :address, :number,
                :account_number, :password,
                :email, :id, :person_type,
                :company_name, :country, :blocked,
                :status, :domains_name

  def initialize(name, surname, address, number, account_number)
    @name = name
    @surname = surname
    @address = address
    @number = number
    @account_number = account_number
    set_default_information('nikaszalias123', 100, false, 3, '')
    set_information('nzaliauskas@gmail.com', 'Company', 'Google', 'USA')
  end

  def set_default_information(password, id, blocked, status, domains_name)
    @password = password
    @id = id
    @blocked = blocked
    @status = status
    @domains_name = domains_name
  end

  def set_information(email, person_type, company_name, country)
    @email = email
    @person_type = person_type
    @company_name = company_name
    @country = country
  end

  def self.from_yaml(obj)
    User.new(obj['name'], obj['surname'], obj['address'],
             obj['number'], obj['account_number'])
  end

  def information_yaml(obj)
    set_default_information(obj['password'], obj['id'], obj['blocked'],
                            obj['status'], obj['domain_name'])
    set_information(obj['email'], obj['person_type'],
                    obj['company_name'], obj['country'])
  end
end
