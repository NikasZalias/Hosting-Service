require 'rspec'
require 'domain'
require 'yaml'

RSpec.describe Domain do
  context 'creation' do
    before(:each) do
      information_yaml = {
          'id' => 1,
          'name' => 'www.nikas.lt',
          'price' => 25
      }.to_yaml
      @domain = Domain.from_yaml(YAML.load(information_yaml))
    end

    it '.initialize id' do
      expect(@domain.id).to eq 1
    end
    it '.initialize name' do
      expect(@domain.name).to eq 'www.nikas.lt'
    end
    it '.initialize price' do
      expect(@domain.price).to eq 25
    end
  end
end