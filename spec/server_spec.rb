require 'rspec'
require './lib/server'
require 'yaml'

RSpec.describe Server do
  context 'creation' do
    before(:each) do
      information_yaml = {
          'id' => 1,
          'name' => 'Simple',
          'price' => 50
      }.to_yaml
      @server = Server.from_yaml(YAML.load(information_yaml))
    end

    it '.initialize id' do
      expect(@server.id).to eq 1
    end
    it '.initialize name' do
      expect(@server.name).to eq 'Simple'
    end
    it '.initialize price' do
      expect(@server.price).to eq 50
    end
  end
end