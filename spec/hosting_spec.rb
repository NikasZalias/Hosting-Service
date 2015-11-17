require 'rspec'
require './lib/hosting'
require './lib/admin'
require './lib/user'
require './lib/server'
require './lib/domain'

RSpec.describe Hosting do
  context 'functions' do
    before(:each) do
      @hosting = Hosting.new('Title', 500_00, 'LT6548978465654')
      @admin = Admin.new(666_999, 'name', 'password', 2)
      @user = User.new('name1', 'surname1', 'address111',
                       862_324_442_4, 'LT6546543198754111116')
      @wrong_user = User.new('Nikas', 'Zalias', 'address111',
                             862_324_333, 'LT6546543198116')
      @server = Server.new(1, 'Simple', 50)
      @domain_end = Domain.new(1, '.lt', 25)
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

    it '.del_admin' do
      @hosting.add_admin(@admin)
      @hosting.del_admin(0)
      expect(@hosting.admin_list.length).to eq 0
    end

    it '.change_title' do
      @hosting.change_title('new0title')
      expect(@hosting.title).to eq 'new0title'
    end

    it '.block_user fail' do
      @hosting.add_user(@user)
      @hosting.block_user(0, @user)
      expect(@user.blocked).to eq false
    end

    it '.block_user' do
      @hosting.add_admin(@admin)
      @hosting.add_user(@user)
      @hosting.block_user(0, @admin)
      expect(@user.blocked).to eq true
    end

    it '.unblock_user' do
      @hosting.add_admin(@admin)
      @hosting.add_user(@user)
      @hosting.unblock_user(0)
      expect(@user.blocked).to eq false
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
      expect(@user.information_array[4]).to eq 'LT6546543198754111116'
    end

    it '.edit' do
      @hosting.add_user(@user)
      @hosting.edit(@user, 'address_new', 863_555_444,
                    'GER987565465464', 'new_password')
      expect(@user.information_array[4]).to eq 'GER987565465464'
    end

    it '.add domain fail' do
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
      @hosting.add_domain_end(@domain_end)
      @hosting.add_user(@user)
      result = @hosting.add_domain('www.nikodemas.lt', @user)
      expect(result).to end_with @hosting.domain_end_list.last.name
    end

    it '.pay_for_hosting' do
      @hosting.add_user(@user)
      @hosting.pay_for_hosting(@user)
      expect(@user.more_info_array[4]).to eq 400
    end

    it '.add_domain check to increase by wanted number' do
      @hosting.add_user(@user)
      @hosting.add_domain('www.nikodemas.lt', @user)
      @hosting.add_domain('www.zaliauskas.lt', @user)
      @hosting.add_domain('www.zaliauskas1.lt', @user)
      @hosting.add_domain('www.zaliauskas2.lt', @user)
      expect(@user.last_info_array[0]).to fantastic_four
    end

    it '.add_domain check hosting money' do
      @hosting.add_user(@user)
      @hosting.add_domain('www.nikodemas.lt', @user)
      @hosting.add_domain('www.nikodemas1.lt', @user)
      @hosting.add_domain('www.nikodemas2.lt', @user)
      @hosting.add_domain('www.nikodemas3.lt', @user)
      @hosting.add_domain('www.nikodemas4.lt', @user)
      expect(@hosting.current_money_count).to eq 504_00
    end

    it '.save_to_file' do
      @hosting.add_user(@user)
      @hosting.add_admin(@admin)
      @hosting.add_server(@server)
      @hosting.save_to_file
      file = File.open('./database/data.yml', 'rb')
      content = file.read
      file_ready = File.open('./database/file_ready', 'rb')
      content_ready = file_ready.read
      expect(content).to eq content_ready
    end

    it '.check_database_path' do
      path = @hosting.check_database_path
      expect(path).to check_file_path('/Database/data.yml')
    end

    # perdaryti
    it '.load_file' do
      @hosting.add_user(@user)
      @hosting.save_to_file
      @hosting.load_file
      file_loaded = @hosting
      File.open('./Database/data_load_test.yml', 'w') do |w|
        w.write @hosting.to_yaml
      end
      file = YAML.load_file('./Database/data.yml')
      expect(file).not_to eq file_loaded
    end

    it '.register' do
      @hosting.add_user(@user)
      @hosting.register('NikasReg', 'ZaliasReg', 'Giedros7Reg',
                        863_330_227, 'LT132165489746546',
                        'nzaliasRed@gmail.com', 'CompanyReg',
                        'GoogleReg', 'LithuaniaReg',
                        500, 'password.123Reg')
      @hosting.save_to_file
      @hosting.load_file
      expect(@hosting.user_list.last)
        .to have_attributes(information_array: ['NikasReg', 'ZaliasReg',
                                                'Giedros7Reg', 863_330_227,
                                                'LT132165489746546'])
    end

    it '.pay_for_server' do
      @hosting.pay_for_server(@user, @server)
      expect(@user.more_info_array[4]).to eq 450
    end

    it '.add_server' do
      @hosting.add_server(@server)
      expect(@hosting.server_list.last).to have_attributes(id: 1,
                                                           name: 'Simple',
                                                           price: 50)
    end

    it '.del_server' do
      @hosting.add_server(@server)
      @hosting.del_server(0)
      expect(@hosting.server_list).to eq []
    end

    it '.add_server_to_user' do
      @hosting.add_user(@user)
      @hosting.add_server(@server)
      @hosting.add_server_to_user(@user, 'Simple')
      expect(@user.last_info_array[1]).to start_with 'Simple'
    end

    it '.add_server_to_user payment' do
      @hosting.add_user(@user)
      @hosting.add_server(@server)
      @hosting.add_server_to_user(@user, 'Simple')
      expect(@user.more_info_array[4]).to eq 450
    end

    it '.add_server_to_user date check' do
      @hosting.add_user(@user)
      @hosting.add_server(@server)
      @hosting.add_server_to_user(@user, 'Simple')
      @hosting.save_to_file
      expect(@user.last_info_array[1]).not_to end_with((Time.now.to_date + 365).to_s)
    end

    it '.add_domain_end' do
      @hosting.add_domain_end(@domain_end)
      expect(@hosting.domain_end_list).to include(@domain_end)
    end

    it '.del_domain_end' do
      @hosting.add_domain_end(@domain_end)
      @hosting.del_domain_end(0)
      expect(@hosting.domain_end_list.length).to eq 0
    end

    it '.find_admin' do
      @hosting.add_admin(@admin)
      admin_found = @hosting.find_admin(666_999)
      expect(admin_found).to eq @admin
    end

    it '.find_user' do
      @hosting.add_user(@user)
      user_found = @hosting.find_user(0)
      expect(user_found).to eq @user
    end

    it 'create_user_id' do
      @hosting.create_user_id(@user)
      @hosting.add_user(@user)
      expect(@hosting.user_list.last.default_info_array[1]).to eq 0
    end
  end
end
