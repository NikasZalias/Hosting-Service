require 'yaml'
require './lib/user'
require './lib/admin'
require './lib/server'
require './lib/domain'
require 'rspec'

# Nikodemas Zaliauskas INFO 3 kursas Hostingo paslaugu servisas
class Hosting
  attr_reader :title, :user_list, :admin_list, :current_money_count,
              :account_number, :server_list, :domain_end_list

  def initialize(title, current_money_count, account_number)
    @user_list = []
    @admin_list = []
    @title = title
    @current_money_count = current_money_count
    @account_number = account_number
    @server_list = []
    @domain_end_list = []
  end

  def add_admin(admin_obj)
    @admin_list << admin_obj
  end

  def add_user(user_obj)
    @user_list << user_obj
  end

  def add_server(server_obj)
    @server_list << server_obj
  end

  def add_domain_end(domain_end_obj)
    @domain_end_list << domain_end_obj
  end

  def del_admin(admin_id)
    @admin_list.delete_at(admin_id)
  end

  def del_user(user_id)
    user_list.delete_at(user_id)
  end

  def del_server(server_id)
    server_list.delete_at(server_id)
  end

  def del_domain_end(domain_id)
    @domain_end_list.delete_at(domain_id)
  end

  def change_title(new_title)
    @title = new_title
  end

  def block_user(user_id, admin)
    temp_id = user_id
    return unless @admin_list.include? admin
    @user_list.each do |user|
      next unless user.default_info_array[1] == temp_id
      user.block
    end
  end

  def unblock_user(user_id)
    temp_id = user_id
    @user_list.each do |user|
      (user.block if user.blocked) if user.default_info_array[1] == temp_id
    end
  end

  def login(email, password)
    temp_email = email
    temp_pass = password
    @user_list.each do |user|
      next unless user.email == temp_email && user.password == temp_pass
      return true
    end
  end

  def admin_login(name, password)
    temp_name = name
    temp_pass = password
    @admin_list.each do |user|
      if user.name == temp_name && user.password == temp_pass
        return true
      else
        return false
      end
    end
  end

  def edit(user, address, number, account_number, password)
    temp_user = user
    @user_list.each do |user_search|
      next unless user_search == temp_user
      user_search.edit(address, number, account_number, password)
    end
  end

  def add_domain(domain_name, user)
    @user_list.each do |user_search|
      if user_search == user
        user_search.domain_name(domain_name)
        fixnum = user_search.domain_count(1)
        if fixnum != 5
          pay_for_hosting(user)
          return domain_name
        else
          return domain_name
        end
      else
        return false
      end
    end
  end

  def pay_for_hosting(user)
    temp_user = user
    @user_list.each do |user_search|
      if user_search == temp_user
        user_search.balance(-100)
        @current_money_count += 100
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

  def check_database_path
    File.absolute_path('./Database/data.yml')
  end

  RSpec::Matchers.define :check_file_path do |expect|
    match do |actual|
      actual[-18..-1] == expect
    end
  end

  def register(name, surname, address, number, account_number,
               email, person_type, company_name, country,
               current_money_count, password)
    user = User.new(name, surname, address, number, account_number)
    user.set_default_information(password, create_user_id(user), false, 3, nil)
    user.set_information(email, person_type, company_name,
                         country, current_money_count)
    user.set_more_info(0, '')
    add_user(user)
  end

  def create_user_id(user_obj)
    temp = @user_list.last
    default_info_array = user_obj.default_info_array
    if @user_list.length == 0
      default_info_array[1] = 0
    else
      default_info_array[1] = temp.default_info_array[1] + 1
    end
  end

  def load_file
    temp = YAML.load_file('./Database/data.yml')
    @admin_list = temp.admin_list
    @user_list = temp.user_list
    @domain_end_list = temp.domain_end_list
    @server_list = temp.server_list
    @title = temp.title
    @current_money_count = temp.current_money_count
    @account_number = temp.account_number
  end

  def load_database
    temp = YAML.load_file('./Database/database.yml')
    @admin_list = temp.admin_list
    @user_list = temp.user_list
    @domain_end_list = temp.domain_end_list
    @server_list = temp.server_list
    @title = temp.title
    @current_money_count = temp.current_money_count
    @account_number = temp.account_number
  end

  def pay_for_server(user, server)
    price = server.price
    user.balance(-price)
    @current_money_count += price
    user
  end

  def add_server_to_user(user, server_name)
    @user_list.each do |user_search|
      next unless user_search == user
      @server_list.each do |server|
        next unless server.name == server_name
        user_search.last_info_array[1] =
            server_name + ' ' + (Time.now.to_date).to_s
        pay_for_server(user, server)
      end
    end
  end

  def find_admin(admin_id)
    temp_admin_id = admin_id
    @admin = nil
    @admin_list.each do |admin_search|
      if admin_search.id == temp_admin_id
        @admin = admin_search
        return @admin
      end
    end
  end

  def find_user(user_id)
    temp_user_id = user_id
    @user = nil
    @user_list.each do |user_search|
      if user_search.default_info_array[1] == temp_user_id
        @user = user_search
        return @user
      end
    end
  end
end
