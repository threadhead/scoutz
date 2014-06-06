require 'spec_helper'

class SubUnitIdWidget
  include ActiveModel::Validations
  include ActiveRecord::AttributeMethods::Serialization
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  include SubUnitIds
  include SendToOptions
  attr_accessor :send_to_option, :sub_unit_ids

  def initialize
    @sub_unit_ids = Array.new
  end

  def unit; nil end
end


RSpec.describe SubUnitIds do
  let(:widget) { SubUnitIdWidget.new }

  describe 'validations' do
    context 'when send_to_option = 3 to send to sub units' do
      before { widget.send_to_option = 3 }
      describe 'and no sub units are selected' do
        specify { expect(widget).not_to be_valid }
        it 'should have errors on base' do
          widget.valid?
          expect(widget.errors).to include(:base)
        end
      end

      describe 'with sub units selected' do
        before { widget.sub_unit_ids = [2] }
        specify { expect(widget).to be_valid }
      end
    end
  end


  describe '.sub_units' do
    before do
      @su1 = FactoryGirl.create(:sub_unit)
      widget.sub_unit_ids << @su1.id
      @su2 = FactoryGirl.create(:sub_unit)
      widget.sub_unit_ids << @su2.id
      @su3 = FactoryGirl.create(:sub_unit)
    end

    specify { expect(widget.sub_units.count).to eq(2) }
    specify { expect(widget.sub_units).to include(@su1) }
    specify { expect(widget.sub_units).to include(@su1) }
    specify { expect(widget.sub_units).not_to include(@su3) }
  end

end
