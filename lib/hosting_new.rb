require 'yaml'
require './lib/user'
require './lib/admin'
require './lib/server'
require './lib/domain'
require 'rspec'

# Nikodemas Zaliauskas INFO 3 kursas Hostingo paslaugu servisas
class HostingNew < Hosting
  def add_domain(domain_name, user)
    user = find_user_obj(user)
    return false unless user
    user.domain_name(domain_name)
    pay_for_hosting(user) unless user.domain_count(1) != 5
    domain_name
  end

  def find_user_obj(user)
    temp = user
    ret = false
    @lists[:user].each do |user_search|
      ret = user_search if user_search == temp
    end
    ret
  end

  def pay_for_hosting(user)
    temp_user = user
    @lists[:user].each do |user_search|
      if user_search == temp_user
        user_search.balance(-100)
        @accounting[:current_money_count] += 100
      end
    end
  end

  RSpec::Matchers.define :fantastic_four do
    match do |actual|
      4 == actual
    end
  end

  def save_to_file
    File.open('./Database/data.yml', 'w') do |write|
      write.write to_yaml
    end
  end

  def save_to_database
    File.open('./Database/database.yml', 'w') do |write|
      write.write to_yaml
    end
  end

  RSpec::Matchers.define :check_file_path do |expect|
    match do |actual|
      actual[-18..-1] == expect
    end
  end

  def register(info)
    user = User.new(info[:name], info[:surname],
                    info[:address], info[:number],
                    info[:account_number])
    user.default_information([info[:password],
                              create_user_id(user), nil, 3, false])
    user.information([info[:email], info[:person_type], info[:company_name],
                      info[:country], info[:current_money_count]])
    user.more_info(0, '')
    add_user(user)
  end

  def create_user_id(user_obj)
    temp = @lists[:user]
    default_info_array = user_obj.default_info_array
    if temp.length == 0
      default_info_array[1] = 0
    else
      default_info_array[1] = temp.last.default_info_array[1] + 1
    end
    @title
  end

  def load_file(path)
    temp = YAML.load_file(path)
    load_lists
    @title = temp.title
    @accounting = temp.accounting
  end

  def load_lists
    lists = YAML.load_file('./Database/data.yml').lists
    @lists[:admin] = lists[:admin]
    @lists[:user] = lists[:user]
    @lists[:domain_end] = lists[:domain_end]
    @lists[:server] = lists[:server]
  end

  def load_database
    temp = YAML.load_file('./Database/database.yml')
    load_lists
    @title = temp.title
    @accounting = temp.accounting
  end

  def pay_for_server(user, server)
    price = server.price
    user.balance(-price)
    @accounting[:current_money_count] += price
    user
  end

  def add_user(user_obj)
    @lists[:user] << user_obj
  end

  def del_domain_end(domain_id)
    @lists[:domain_end].delete_at(domain_id)
  end

  def change_title(new_title)
    @title = new_title
  end
end
