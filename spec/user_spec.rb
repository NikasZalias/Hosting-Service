require 'user'
require 'rspec'
require 'yaml'

RSpec.describe User do
  context 'creation' do
    before(:each) do
      information_yaml = {
        'name' => 'Nikas',
        'surname' => 'Zalias',
        'address' => 'Giedros 7',
        'number' => 863_330_227,
        'account_number' => 'LT123456789321654987'
      }.to_yaml
      @user = User.from_yaml(YAML.load(information_yaml))
      information_yaml = {
          'password' => 'nikaszalias123',
          'id' => 100,
          'blocked' => 'false',
          'email' => 'nzaliauskas@gmail.com',
          'person_type' => 'Company',
          'company_name' => 'Google',
          'country' => 'USA'
      }.to_yaml
      @user.information_yaml(YAML.load(information_yaml))

    end

    it '.initialize name' do
      expect(@user.name).to eq 'Nikas'
    end

    it '.initialize surname' do
      expect(@user.surname).to eq 'Zalias'
    end

    it '.initialize address' do
      expect(@user.address).to eq 'Giedros 7'
    end

    it '.initialize number' do
      expect(@user.number).to eq 863_330_227
    end

    it '.initialize account_number' do
      expect(@user.account_number).to eq 'LT123456789321654987'
    end

    it '.initialize password' do
      expect(@user.password).to eq 'nikaszalias123'
    end

    it '.initialize id' do
      expect(@user.id).to eq 100
    end

    it '.initialize email' do
      expect(@user.email).to eq 'nzaliauskas@gmail.com'
    end

    it '.initialize person_type' do
      expect(@user.person_type).to eq 'Company'
    end

    it '.initialize company_name' do
      expect(@user.company_name).to eq 'Google'
    end

    it '.initialize country' do
      expect(@user.country).to eq 'USA'
    end
  end
end
