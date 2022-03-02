require 'spec_helper'

describe 'Configurator' do
  before(:each) do
    App.clear_config
    App.config.files_path = File.join(File.dirname(__FILE__), '../data/')
  end

  context 'loading' do
    it '.load_all!' do
      expect { App.config.load_all! }.not_to raise_error
    end

    it '.load! - valid file' do
      expect { App.config.load!(:db) }.not_to raise_error
    end

    it '.load! - invalid file' do
      expect { App.config.load!(:dbs) }.to raise_error /Configuration file.*doesn't exist on path/
    end
  end

  context 'content' do
    it 'all config files' do
      App.config.load_all!

      aggregate_failures do
        expect(App.config.test.display_errors).to be true
        expect(App.config.db.username).to eq('admin')
      end
    end

    it 'single file' do
      App.config.load!(:db)
      expect(App.config.db.username).to eq('admin')
    end

    it 'erb content' do
      App.config.load!(:test)
      expect(App.config.test.error_id).to eq('error_2')
    end

    it 'erb content - boolean' do
      App.config.load!(:test)
      expect(App.config.test.boolean).to eq(true)
    end
  end
end