# frozen_string_literal: true

RSpec.describe Procreate::Swatches::Exporter do
  let(:default_name) { 'SpecSwatch' }
  let(:default_directory) { Dir.pwd }
  let(:colors) { ['#abc', '#cde'] }
  let(:wrapper) { Procreate::Swatches::Wrapper.new(default_name, colors) }
  let(:custom_name) { 'SpecLandscape' }
  let(:described_instance) { described_class.new(wrapper) }
  let(:instance_custom_name) { described_class.new(wrapper, file_name: custom_name) }
  let(:unpremitted_options) { { wrong: true, unpremitted: true } }

  context 'when calling methods and aliases' do
    it { expect(described_class).to respond_to(:call).with(1..2).arguments }
    it { expect(described_instance).to respond_to(:call).with(0).arguments }

    it { expect(described_instance).to respond_to(:export).with(0).arguments }
  end

  context 'when calling attributes' do
    it { expect(described_instance).to have_attributes(wrapper: wrapper) }
    it { expect(described_instance.wrapper).to be_kind_of(Procreate::Swatches::Wrapper) }
    it { expect(described_instance.options).to be_kind_of(Hash) }
  end

  context 'when testing options, default options and options restriction' do
    it { expect(described_instance.options).to include(export_directory: default_directory) }
    it { expect(instance_custom_name.options).to include(file_name: custom_name, export_directory: default_directory) }

    it 'discards unpermitted options' do
      described_instance.options = unpremitted_options

      expect(described_instance.options).not_to include(**unpremitted_options)
      expect(described_instance.options).to include(export_directory: default_directory)
    end
  end

  context 'when exporting `.swatches` file' do
    subject { described_instance.export }

    it { is_expected.to be_kind_of(String) }
    it { is_expected.to include(default_directory) }
    it { is_expected.to include(default_name) }
    it { is_expected.to match(/.*-\d{1,}\.swatches\z/) }
    it { is_expected.to eq(described_instance.zip_path) }
  end
end
