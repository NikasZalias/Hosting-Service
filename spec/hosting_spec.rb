require 'rspec'
require 'hosting'
require 'admin'
require 'user'

RSpec.describe Hosting do
  context 'functions' do
    before(:each) do
      @hosting = Hosting.new('Title', 50000, 'LT6548978465654')
      @admin = Admin.new(1, 'name', 'password', 2)
      @user = User.new('name1', 'surname1', 'address111',
                       862_324_442_4, 'LT6546543198754111116')
      @wrong_user = User.new('Nikas', 'Zalias', 'address111',
                             862_324_333, 'LT6546543198116')
    end

    it '.add_admin' do
      @hosting.add_admin(@admin)
      expect(@hosting.admin_list).to include(@admin)
    end

    it '.add_user' do
      @hosting.add_user(@user)
      expect(@hosting.user_list).not_to be_nil
    end

    it '.del_user' do
      @hosting.add_user(@user)
      @hosting.del_user(0)
      expect(@hosting.user_list.length).to eq 0
    end

    it '.change_title' do
      @hosting.change_title('new0title')
      expect(@hosting.title).to eq 'new0title'
    end

    it '.block_user fail' do
      @hosting.add_user(@user)
      @hosting.block_user(100, @user)
      expect(@user.blocked).to eq false
    end

    it '.block_user' do
      @hosting.add_admin(@admin)
      @hosting.add_user(@user)
      @hosting.block_user(100, @admin)
      expect(@user.blocked).to eq true
    end

    it '.login' do
      @hosting.add_user(@user)
      result = @hosting.login('nzaliauskas@gmail.com', 'nikaszalias123')
      expect(result).to eq true
    end

    it '.admin_login user fail' do
      @hosting.add_user(@user)
      @hosting.add_admin(@admin)
      result = @hosting.admin_login('nzaliauskas@gmail.com', 'nikaszalias123')
      expect(result).to eq false
    end

    it '.admin_login' do
      @hosting.add_admin(@admin)
      result = @hosting.admin_login('name', 'password')
      expect(result).to eq true
    end

    it '.edit fail' do
      @hosting.edit(@user, 'address1', 853_332_578,
                    'EU97879879879', 'fakepass123')
      expect(@user.account_number).to eq 'LT6546543198754111116'
    end

    it '.edit' do
      @hosting.add_user(@user)
      @hosting.edit(@user, 'address_new', 863_555_444,
                    'GER987565465464', 'new_password')
      expect(@user.account_number).to eq 'GER987565465464'
    end

    it '.add_domain fail' do
      @hosting.add_user(@user)
      result = @hosting.add_domain('www.nzaliauskas.lt', @wrong_user)
      expect(result).to eq false
    end

    it '.add_domain' do
      @hosting.add_user(@user)
      result = @hosting.add_domain('www.nikodemas.lt', @user)
      expect(result).to eq 'www.nikodemas.lt'
    end

    it '.add_domain result begin check' do
      @hosting.add_user(@user)
      result = @hosting.add_domain('www.nikodemas.lt', @user)
      expect(result).to start_with 'www.'
    end

    it '.add_domain result end check' do
      @hosting.add_user(@user)
      result = @hosting.add_domain('www.nikodemas.lt', @user)
      expect(result).to end_with '.lt'
      # Can I check domain's endings from the list?
    end

    it '.pay_for_hosting' do
      @hosting.add_user(@user)
      @hosting.pay_for_hosting(@user)
      expect(@user.current_money_count).to eq 400
    end
    it '.add_domain check to increase by wanted number' do
      @hosting.add_user(@user)
      @hosting.add_domain('www.nikodemas.lt', @user)
      @hosting.add_domain('www.zaliauskas.lt', @user)
      @hosting.add_domain('www.zaliauskas1.lt', @user)
      @hosting.add_domain('www.zaliauskas2.lt', @user)
      expect(@user.domain_count).to fantastic_four
    end

    it '.add_domain check hosting money' do
      @hosting.add_user(@user)
      @hosting.add_domain('www.nikodemas.lt', @user)
      expect(@hosting.current_money_count).to eq 50100
    end
  end
end

