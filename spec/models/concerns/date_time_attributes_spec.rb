require 'rails_helper'

RSpec.describe 'DateTimeAttributes Concern' do
  before(:all) do
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')

    ActiveRecord::Schema.define(version: 1) do
      create_table :attr_items do |t|
        t.datetime :start_at
        t.datetime :end_at
      end
    end

    class AttrItem < ActiveRecord::Base
      include DateTimeAttributes
      date_time_attribute :start_at
    end
  end

  after(:all) do
    ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations['test'])
  end

  let(:attr_item) { AttrItem.new(start_at: '2014-02-02 08:08:08') }


  describe 'creates ATTR_date/= and ATTR_time/= methods' do
    specify { expect(AttrItem.method_defined?('start_at_date')).to eq(true) }
    specify { expect(AttrItem.method_defined?('start_at_date=')).to eq(true) }
    specify { expect(AttrItem.method_defined?('start_at_time')).to eq(true) }
    specify { expect(AttrItem.method_defined?('start_at_time=')).to eq(true) }
  end

  describe 'ATTR_date and ATTR_time will be set to appropriate values' do
    specify { expect(attr_item.start_at_date).to eq('Feb 02, 2014') }
    specify { expect(attr_item.start_at_time).to eq('08:08am') }
  end

  it 'setting ATTR_date and ATTR_time updates ATTR' do
    attr_item.start_at_date = 'Aug 22, 1999'
    attr_item.start_at_time = '09:09pm'
    expect(attr_item.start_at).to be_within(1).of(Time.zone.parse '1999-08-22 21:09:00')

    attr_item.start_at_time = '03:03pm'
    attr_item.start_at_date = 'Apr 12, 1991'
    expect(attr_item.start_at).to be_within(1).of(Time.zone.parse '1991-04-12 15:03:00')
  end

  it 'sets ATTR to nil if bad dates or times' do
    attr_item.start_at_date = 'asdf'
    expect(attr_item.start_at).to eq(nil)

    attr_item.start_at_time = 'asdfasdf'
    expect(attr_item.start_at).to eq(nil)
  end

  it 'does not affect non-specified attributes' do
    expect(AttrItem.method_defined?('end_at_date')).to eq(false)
    expect(AttrItem.method_defined?('end_at_date=')).to eq(false)
    expect(AttrItem.method_defined?('end_at_time')).to eq(false)
    expect(AttrItem.method_defined?('end_at_time=')).to eq(false)
  end
end
