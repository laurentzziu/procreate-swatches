# frozen_string_literal: true

RSpec.describe Procreate::Swatches::Wrapper do
  let(:hex_colors) { ['#abc', '#def'] }
  let(:chroma_colors) { [Chroma::Color.new(+'#abc'), Chroma::Color.new(+'#def')] }
  let(:invalid_colors) { ['zzz', 'xxx', 'yyy'] }
  let(:valid_color) { '#aaa' }
  let(:name) { 'Spec Swatches' }
  let(:described_instance) { described_class.new(name, chroma_colors) }
  let(:raw_json) { described_instance.to_json }
  let(:parsed_json) { JSON.parse(raw_json) }
  let(:parsed_json_name) { parsed_json.first['name'] }
  let(:parsed_json_colors) { parsed_json.first['swatches'] }
  let(:parsed_json_first_color) { parsed_json.first['swatches'].first }
  let(:hsv_test_color) { chroma_colors.first.hsv }
  let(:initial_wrapper_colors) { described_instance.colors }

  context 'when calling methods and aliases' do
    subject { described_instance }

    it { expect(subject).to respond_to(:to_json) }
    it { expect(subject).to respond_to(:to_swatches) }
    it { expect(subject).to respond_to(:to_procreate) }

    it { expect(subject).to respond_to(:to_file).with(1).argument }
    it { expect(subject).to respond_to(:export).with(1).argument }

    it { expect(subject).to respond_to(:<<).with(1).argument }
    it { expect(subject).to respond_to(:push).with(1).argument }

    it { expect(subject).to respond_to(:pop) }
  end

  context 'when calling attributes' do
    it { expect(described_instance.name).to eq(name) }
    it { expect(described_instance.colors).to eq(chroma_colors) }
    it { expect(described_class.new(name, hex_colors)).to eq(described_class.new(name, chroma_colors)) }
    it { expect(described_class.new(nil, nil)).to have_attributes(name: described_class::DEFAULT_SWATCHES_NAME, colors: []) }
  end

  context 'when generating JSON content' do
    context 'when testing raw JSON content' do
      subject { raw_json }

      it { expect(subject).to be_kind_of(String) }
      it { expect(subject).to eq(described_instance.to_swatches) }
      it { expect(subject).to eq(described_instance.to_procreate) }
    end

    context 'when testing parsed JSON content' do
      context 'whole content' do
        it { expect(parsed_json).to be_kind_of(Array) }
        it { expect(parsed_json.count).to eq(1) }
        it { expect(parsed_json_name).to eq(name) }
        it { expect(parsed_json_colors.size).to eq(chroma_colors.size) }
        it { expect(parsed_json_colors.size).to be <= Procreate::Swatches::ColorsHelper::SWATCHES_MAX_SIZE }
      end

      context 'a color' do
        subject { parsed_json_first_color }

        it { expect(subject).to be_kind_of(Hash) }
        it { expect(subject).to include('hue' => hsv_test_color.h / 360, 'saturation' => hsv_test_color.s, 'brightness' => hsv_test_color.v, 'alpha' => 1, 'colorSpace' => 0) }
        it { expect(subject['hue']).to be_between(0, 1) }
        it { expect(subject['saturation']).to be_between(0, 1) }
        it { expect(subject['brightness']).to be_between(0, 1) }
        it { expect(subject['hue']).to be_kind_of(Float) }
        it { expect(subject['saturation']).to be_kind_of(Float) }
        it { expect(subject['brightness']).to be_kind_of(Float) }
      end
    end
  end

  context 'when adding a new color' do
    context 'that is valid' do
      subject { described_instance << valid_color }

      it { expect { subject }.to change { described_instance.colors.size }.by(1) }
      it { expect(subject).to be_kind_of(Array) }
    end

    context 'that is invalid' do
      subject { described_instance << (invalid_colors.sample) }

      it { expect { subject }.not_to change { described_instance.colors.size } }
      it { expect(subject).to be_kind_of(Array) }
      it { expect(subject).to eq(initial_wrapper_colors) }
    end
  end

  context 'when removing a color' do
    it { expect { described_instance.pop }.to change { described_instance.colors.size}.by(-1) }
  end

  context 'when exporting swatches to file' do
    subject { described_instance.to_file }

    it { expect(subject).to be_kind_of(String) }
    it { expect(subject).to include(described_instance.name) }
  end
end