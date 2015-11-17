require 'yaml'
require 'json'

# Nikodemas Zaliauskas INFO 3 kursas Hostingo paslaugu servisas
class User
  attr_reader :information_array, :default_info_array,
              :more_info_array, :last_info_array, :blocked

  def initialize(name, surname, address, number, account_number)
    @information_array = [name, surname, address, number, account_number]
    set_default_information('nikaszalias123', 0, false, 3, '')
    set_information('nzaliauskas@gmail.com', 'Company', 'Google', 'USA', 500)
    set_more_info(0, 'default')
  end

  public def set_default_information(password, id, blocked,
                                     status, domains_name)
    @default_info_array = [password, id, status, domains_name]
    @blocked = blocked
  end

  public def set_information(email, person_type, company_name,
                             country, current_money_count)
    @more_info_array = [email, person_type, company_name,
                        country, current_money_count]
  end

  public def set_more_info(domain_count, server)
    @last_info_array = [domain_count, server]
  end

  def self.from_yaml(obj)
    User.new(obj['name'], obj['surname'], obj['address'],
             obj['number'], obj['account_number'])
  end

  def information_yaml(obj)
    set_default_information(obj['password'], obj['id'], obj['blocked'],
                            obj['status'], obj['domain_name'])
    set_information(obj['email'], obj['person_type'],
                    obj['company_name'], obj['country'],
                    obj['current_money_count'])
    set_more_info(obj['domain_count'], obj['server'])
  end

  def block
    @blocked ? @blocked = false : @blocked = true
  end

  def edit(address, number, account_number, password)
    @information_array[2] = address
    @information_array[3] = number
    @information_array[4] = account_number
    @default_info_array[0] = password
  end

  def email
    @more_info_array[0]
  end

  def password
    @default_info_array[0]
  end

  def domain_name(name)
    @more_info_array[0] = name
  end

  def domain_count(value)
    @last_info_array[0] += value
  end

  def balance(val)
    @more_info_array[4] += val
  end
end
