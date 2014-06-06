require 'spec_helper'

class SendToWidget
  include SendToOptions
  attr_accessor :send_to_option
end


RSpec.describe SendToOptions do

  describe '.send_to_options' do
    context 'with a cub scout pack' do
      let(:unit) { FactoryGirl.build(:unit) }

      specify { expect(SendToWidget.send_to_options(unit)).to be_a(Array) }
      specify { expect(SendToWidget.send_to_options(unit)[0]).to eq(['Everyone in Cub Scout Pack 134', 1]) }
      specify { expect(SendToWidget.send_to_options(unit)[1]).to eq(['Cub Scout Pack 134 Leaders', 2]) }
      specify { expect(SendToWidget.send_to_options(unit)[2]).to eq(['Selected Dens', 3]) }
      specify { expect(SendToWidget.send_to_options(unit)[3]).to eq(['Selected Adults/Scouts', 4]) }
    end

    context 'with a boy scout troop' do
      let(:unit) { FactoryGirl.build(:unit, unit_type: 'Boy Scouts', unit_number: '515') }

      specify { expect(SendToWidget.send_to_options(unit)).to be_a(Array) }
      specify { expect(SendToWidget.send_to_options(unit)[0]).to eq(['Everyone in Boy Scout Troop 515', 1]) }
      specify { expect(SendToWidget.send_to_options(unit)[1]).to eq(['Boy Scout Troop 515 Leaders', 2]) }
      specify { expect(SendToWidget.send_to_options(unit)[2]).to eq(['Selected Patrols', 3]) }
      specify { expect(SendToWidget.send_to_options(unit)[3]).to eq(['Selected Adults/Scouts', 4]) }
    end
  end


  context 'send_to_xxx?' do
    let(:widget) { SendToWidget.new }

    it 'returns true when send_to_unit' do
      widget.send_to_option = 1
      expect(widget.send_to_unit?).to eq(true)
    end

    it 'returns true when send_to_leaders' do
      widget.send_to_option = 2
      expect(widget.send_to_leaders?).to eq(true)
    end

    it 'returns true when send_to_sub_units' do
      widget.send_to_option = 3
      expect(widget.send_to_sub_units?).to eq(true)
    end

    it 'returns true when send_to_users' do
      widget.send_to_option = 4
      expect(widget.send_to_users?).to eq(true)
    end
  end

end
