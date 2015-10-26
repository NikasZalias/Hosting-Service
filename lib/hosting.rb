require 'json'
require 'user'
require 'admin'
# Nikodemas Zaliauskas INFO 3 kursas Hostingo paslaugu servisas
class Hosting
  attr_reader :title, :user_list, :admin_list, :current_money_count

  def initialize(title, current_money_count)
    @user_list = []
    @admin_list = []
    @title = title
    @current_money_count = current_money_count
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
        return domain_name
      else
        return false
      end
    end
  end

  def pay_for_hosting(user, hosting)
    @user_list.each do |i|
      if i == user
        i.current_money_count = i.current_money_count - 100
        @current_money_count = @current_money_count + 100
      end
    end
  end
end
