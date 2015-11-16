require 'rspec'
require 'yaml'
require './lib/admin'

RSpec.describe User do
  context 'creation' do
    before(:each) do
      information_yaml = {
        'id' => 2,
        'name' => 'admin_hosting',
        'password' => '123.admin.123',
        'status' => 2
      }.to_yaml
      @admin = Admin.from_yaml(YAML.load(information_yaml))
    end

    it '.initialize id' do
      expect(@admin.id).to eq 2
    end
    it '.initialize name' do
      expect(@admin.name).to eq 'admin_hosting'
    end
    it '.initialize password' do
      expect(@admin.password).to eq '123.admin.123'
    end
    it '.initialize status' do
      expect(@admin.status).to eq 2
    end
  end
end
