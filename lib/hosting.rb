require 'yaml'
require 'user'
require 'admin'
# Nikodemas Zaliauskas INFO 3 kursas Hostingo paslaugu servisas
class Hosting
  attr_reader :title, :user_list, :admin_list, :current_money_count, :account_number

  def initialize(title, current_money_count, account_number)
    @user_list = []
    @admin_list = []
    @title = title
    @current_money_count = current_money_count
    @account_number = account_number
  end

  def add_admin(obj)
    @admin_list << obj
  end

  def add_user(obj)
    @user_list << obj
  end

  def del_user(user_id)
    user_list.delete_at(user_id)
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
      p self.to_yaml
    end
  end
end
