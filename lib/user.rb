require 'yaml'
require 'json'

# Nikodemas Zaliauskas INFO 3 kursas Hostingo paslaugu servisas
class User
  attr_reader :information_array, :default_info_array,
              :more_info_array, :last_info_array, :blocked

  def initialize(name, surname, address, number, account_number)
    @information_array = [name, surname, address, number, account_number]
    default_information(['nikaszalias123', 0, '', 3, false])
    information(['nzaliauskas@gmail.com', 'Company', 'Google', 'USA', 500])
    more_info(0, 'default')
  end

  public def default_information(info_array)
    @default_info_array = info_array
  end

  public def information(set_new_info)
    @more_info_array = set_new_info
  end

  public def more_info(domain_count, server)
    @last_info_array = [domain_count, server]
  end

  def block
    if @default_info_array[4]
      @default_info_array[4] = false
    else
      @default_info_array[4] = true
    end
  end

  def edit(new_info)
    @information_array[2] = new_info[0]
    @information_array[3] = new_info[1]
    @information_array[4] = new_info[2]
    @default_info_array[0] = new_info[3]
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
