require 'yaml'
require './lib/user'
require './lib/admin'
require './lib/server'
require './lib/domain'
require 'rspec'

# Nikodemas Zaliauskas INFO 3 kursas Hostingo paslaugu servisas
class Hosting
  attr_reader :title, :lists, :accounting

  def initialize(title)
    @title = title
    @accounting = { current_money_count: 500_00, account_number: '' }
    @lists = { server: [], domain_end: [], admin: [], user: [] }
  end

  def add_admin(admin_obj)
    @lists[:admin] << admin_obj
  end

  def add_server_to_user(user, server_name)
    user = find_user_obj(user)
    @lists[:server].each do |server|
      next unless server.name == server_name
      user.last_info_array[1] =
          server_name + ' ' + (Time.now.to_date).to_s
      pay_for_server(user, server)
    end
  end

  def add_server(server_obj)
    @lists[:server] << server_obj
  end

  def add_domain_end(domain_end_obj)
    @lists[:domain_end] << domain_end_obj
  end

  def del_admin(admin_id)
    @lists[:admin].delete_at(admin_id)
  end

  def del_user(user_id)
    @lists[:user].delete_at(user_id)
  end

  def del_server(server_id)
    @lists[:server].delete_at(server_id)
  end

  def block_user(user_id, admin)
    temp_id = user_id
    return unless @lists[:admin].include? admin
    @lists[:user].each do |user|
      next unless user.default_info_array[1] == temp_id
      user.block
    end
  end

  def unblock_user(user_id)
    temp_id = user_id
    @lists[:user].each do |user|
      (user.block if user.blocked) if user.default_info_array[1] == temp_id
      @title
    end
    @title
  end

  def login(email, password)
    temp = [email, password]
    @lists[:user].each do |user|
      next unless user.email == temp[0] && user.password == temp[1]
      return true
    end
    @title
  end

  def admin_login(name, password)
    temp = [name, password]
    @lists[:admin].each do |user|
      if user.name == temp[0] && user.password == temp[1]
        return true
      else
        return false
      end
    end
    @title
  end

  def edit(user, edits)
    temp_user = user
    @lists[:user].each do |user_search|
      next unless user_search == temp_user
      user_search.edit(edits)
      @title
    end
  end

  def find_user(user_id)
    temp_user_id = user_id
    @user = nil
    @lists[:user].each do |user_search|
      if user_search.default_info_array[1] == temp_user_id
        @user = user_search
        return @user
      end
    end
  end

  def find_admin(admin_id)
    temp_admin_id = admin_id
    @admin = nil
    @lists[:admin].each do |admin_search|
      if admin_search.id == temp_admin_id
        @admin = admin_search
        return @admin
      end
    end
  end
end
