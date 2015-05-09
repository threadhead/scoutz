require 'rails_helper'

RSpec.describe 'AttributeSanitizer Concern' do
  before(:all) do
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

    ActiveRecord::Schema.define(version: 1) do
      create_table :dirty_items do |t|
        t.text :body
        t.text :email
        t.text :name
      end
    end

    class DirtyItem < ActiveRecord::Base
      include AttributeSanitizer
      sanitize_attributes :body, :email
    end
  end

  after(:all) do
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])
  end

  let(:dirty_item) { DirtyItem.new(body: 'humpty', email: 'dumpty', name: 'Karl Smith') }

  before do
    allow(Sanitize).to receive(:clean).and_return('sanitized!')
    dirty_item.save
    dirty_item.reload
  end

  it 'sanitizes passed attributes' do
    expect(dirty_item.body).to eq('sanitized!')
    expect(dirty_item.email).to eq('sanitized!')
  end

  it 'does not sanitize non-specified attributes' do
    expect(dirty_item.name).to eq('Karl Smith')
  end
end
