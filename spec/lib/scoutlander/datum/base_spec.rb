require 'rails_helper'

RSpec.describe Scoutlander::Datum::Base do
  let(:base) { Scoutlander::Datum::Base.new }

  describe '.delete_attributes' do
    before { base.attributes = [:name, :start_at, :inspected] }

    specify { expect(base.delete_attributes).not_to equal(base.attributes) }
    specify { expect(base.delete_attributes).to eq(base.attributes) }
    specify { expect(base.delete_attributes(:name)).to eq([:start_at, :inspected]) }
    specify { expect(base.delete_attributes(:name, :start_at)).to eq([:inspected]) }
    specify { expect(base.delete_attributes(:name, :start_at, :inspected)).to eq([]) }
  end

  describe '.to_params_without' do
    before do
      base.attributes = [:name, :start_at, :inspected]
      base.create_setters_getters_instance_variables({})
      base.name = 'Karl'
      base.start_at = DateTime.new(2014,1,1,23,15,00)
    end

    specify { expect(base.to_params_without).to eq({ name: 'Karl', start_at: base.start_at, inspected: false} ) }
    specify { expect(base.to_params_without(:inspected)).to eq({ name: 'Karl', start_at: base.start_at }) }
    specify { expect(base.to_params_without(:name, :inspected)).to eq({ start_at: base.start_at }) }
    specify { expect(base.to_params_without(:name, :inspected, :start_at)).to eq({}) }

    it 'does not return nil values' do
      base.name = nil
      expect(base.to_params_without(:inspected)).to eq({ start_at: base.start_at })
    end
  end

end
