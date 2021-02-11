require 'spec_helper'

describe 'Configurator' do
  before(:each) do
    App.clear_config
    App.config.files_path = File.join(File.dirname(__FILE__), '../data/')
  end

  it '.load_all!' do
    App.config.load_all!

    aggregate_failures do
      expect(App.config.test.display_errors).to be true
      expect(App.config.db.username).to eq('admin')
    end
  end

  it '.load! - valid file' do
    App.config.load!(:db)
    expect(App.config.db.username).to eq('admin')
  end

  it '.load! - invalid file' do
    expect { App.config.load!(:dbs) }.to raise_error /Configuration file.*doesn't exist on path/
  end
end