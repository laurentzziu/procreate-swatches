# frozen_string_literal: true

require 'pry'

RSpec.describe Procreate::Swatches::Parser do
  before(:all) do
    @swatches_file_name = 'snowy_landscape_2.swatches'
    @spec_swatches_file_path = path_for_file(@swatches_file_name)
    @new_instance = described_class.new(@spec_swatches_file_path)
  end

  context 'when testing validations' do
    context 'when providing nil path' do
      it { expect { described_class.new(nil) }.to raise_error(Procreate::Swatches::Errors::InvalidPath) }
    end

    context 'when providing path with invalid extension' do
      it 'raises an exception' do
        expect do
          described_class.new(path_for_file('snowy_landscape.zip'))
        end.to raise_error(Procreate::Swatches::Errors::InvalidFormat)
      end
    end

    context 'when providing a valid path and extension' do
      it { expect(@new_instance).to be_kind_of(described_class) }
    end
  end

  context 'when calling to execute' do
    it { expect(described_class).to respond_to(:call).with(1).argument }

    it { expect(@new_instance).to respond_to(:call).with(0).arguments }
  end

  context 'when calling attributes' do
    before(:context) do
      @instance = @new_instance.call
    end

    it { expect(@new_instance.file_path).to be_kind_of(String) }
    it { expect(@new_instance.wrapper).to be_kind_of(Procreate::Swatches::Wrapper) }
    it { expect(@new_instance.content).to be_kind_of(Hash) }
  end
end
