require 'yaml'
require 'user'
require 'admin'
require 'server'
require 'domain'

# Nikodemas Zaliauskas INFO 3 kursas Hostingo paslaugu servisas
class Hosting
  attr_reader :title, :user_list, :admin_list, :current_money_count, :account_number, :server_list, :domain_end_list

  def initialize(title, current_money_count, account_number)
    @user_list = []
    @admin_list = []
    @title = title
    @current_money_count = current_money_count
    @account_number = account_number
    @server_list = []
    @domain_end_list = []
  end

  def add_admin(obj)
    @admin_list << obj
  end

  def add_user(obj)
    @user_list << obj
  end

  def add_server(obj)
    @server_list << obj
  end

  def add_domain_end(obj)
    @domain_end_list << obj
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
    return unless @admin_list.include? admin
    @user_list.each do |j|
      next unless j.id == user_id
      j.blocked = true
    end
  end

  def login(email, password)
    @user_list.each do |i|
      next unless i.email == email && i.password == password
      return true
    end
  end

  def admin_login(name, password)
    @admin_list.each do |i|
      if i.name == name && i.password == password
        return true
      else
        return false
      end
    end
  end

  def edit(user, address, number, account_number, password)
    @user_list.each do |i|
      next unless i == user
      i.address = address
      i.number = number
      i.account_number = account_number
      i.password = password
    end
  end

  def add_domain(domain_name, user)
    @user_list.each do |i|
      if i == user
        i.domains_name = domain_name
        i.domain_count = i.domain_count + 1
        if i.domain_count < 5
          pay_for_hosting(user)
          return domain_name
        else if i.domain_count > 5
               pay_for_hosting(user)
               return domain_name
             else
               return domain_name
             end
        end
      else
        return false
      end
    end
  end

  def pay_for_hosting(user)
    @user_list.each do |i|
      if i == user
        i.current_money_count = i.current_money_count - 100
        @current_money_count = @current_money_count + 100
      end
    end
  end

  RSpec::Matchers.define :fantastic_four do 4
    match do |actual|
      4 == actual
    end
  end

  def save_to_file
    File.open('./Database/data.yml', 'w') do |w|
      w.write self.to_yaml
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

  def register(name, surname, address, number, account_number, email, person_type, company_name, country,
               current_money_count, password)
    user = User.new(name, surname, address, number, account_number)
    user.set_default_information(password, create_user_id(user), false, 3, nil)
    user.set_information(email, person_type, company_name, country, current_money_count)
    user.set_more_info(0, '')
    add_user(user)
  end

  def create_user_id(obj)
    temp = @user_list.last
    if temp == nil
      obj.id = 0
    else
      obj.id = temp.id + 1
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

  def pay_for_server(user, server)
    user.current_money_count = user.current_money_count - server.price
    @current_money_count = @current_money_count + server.price
  end

  def add_server_to_user(user, server_name)
    @user_list.each do |i|
      if i == user
        @server_list.each do |j|
          if j.name == server_name
            i.server = server_name + ' ' + (Time.now.to_date).to_s
            pay_for_server(user, j)
          end
        end
      end
    end
  end


end
