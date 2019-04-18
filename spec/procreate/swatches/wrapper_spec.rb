# frozen_string_literal: true

RSpec.describe Procreate::Swatches::Wrapper do
  let(:hex_colors) { %w[#aabbcc #ddeeff] }
  let(:hex8_colors) { %w[#ffaabbcc #ffddeeff] }
  let(:hsl_colors) { ['hsl(210, 25%, 73%)', 'hsl(210, 100%, 93%)'] }
  let(:hsv_colors) { ['hsv(210, 17%, 80%)', 'hsv(210, 13%, 100%)'] }
  let(:rgb_colors) { ['rgb(170, 187, 204)', 'rgb(221, 238, 255)'] }
  let(:chroma_colors) { hex_colors.map { |hex| Chroma::Color.new(+hex) } }
  let(:invalid_colors) { %w[zzz xxx yyy] }
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

    it { is_expected.to respond_to(:to_json).with(0).arguments }
    it { is_expected.to respond_to(:to_swatches).with(0).arguments }
    it { is_expected.to respond_to(:to_procreate).with(0).arguments }

    it { is_expected.to respond_to(:to_file).with(1).argument }
    it { is_expected.to respond_to(:export).with(1).argument }

    it { is_expected.to respond_to(:<<).with(1).argument }
    it { is_expected.to respond_to(:push).with(1).argument }

    it { is_expected.to respond_to(:pop).with(0).arguments }

    it { is_expected.to respond_to(:colors).with_keywords(:format) }
  end

  context 'when calling attributes' do
    it { expect(described_instance.name).to eq(name) }
    it { expect(described_instance.colors).to eq(chroma_colors) }
    it { expect(described_instance.colors(format: :hex)).to match(hex_colors) }
    it { expect(described_instance.colors(format: :hex8)).to match(hex8_colors) }
    it { expect(described_instance.colors(format: :rgb)).to match(rgb_colors) }
    it { expect(described_instance.colors(format: :hsl)).to match(hsl_colors) }
    it { expect(described_instance.colors(format: :hsv)).to match(hsv_colors) }
    it { expect(described_instance.colors(format: :invalid_format)).to match(chroma_colors) }
    it { expect(described_class.new(name, hex_colors)).to eq(described_class.new(name, chroma_colors)) }
    it 'has the expected attributes' do
      expect(described_class.new(nil, nil)).to have_attributes(
        name: described_class::DEFAULT_SWATCHES_NAME,
        colors: []
      )
    end
  end

  context 'when generating JSON content' do
    context 'when testing raw JSON content' do
      subject { raw_json }

      it { is_expected.to be_kind_of(String) }
      it { is_expected.to eq(described_instance.to_swatches) }
      it { is_expected.to eq(described_instance.to_procreate) }
    end

    context 'when testing parsed JSON content' do
      context 'when testing the whole content' do
        it { expect(parsed_json).to be_kind_of(Array) }
        it { expect(parsed_json.count).to eq(1) }
        it { expect(parsed_json_name).to eq(name) }
        it { expect(parsed_json_colors.size).to eq(chroma_colors.size) }
        it { expect(parsed_json_colors.size).to be <= Procreate::Swatches::ColorsHelper::SWATCHES_MAX_SIZE }
      end

      context 'when testing a color' do
        subject(:color) { parsed_json_first_color }

        it { is_expected.to be_kind_of(Hash) }
        it 'has the expected attributes' do
          expect(color).to include(
            'hue' => hsv_test_color.h / 360,
            'saturation' => hsv_test_color.s,
            'brightness' => hsv_test_color.v, 'alpha' => 1, 'colorSpace' => 0
          )
        end
        it { expect(color['hue']).to be_between(0, 1) }
        it { expect(color['saturation']).to be_between(0, 1) }
        it { expect(color['brightness']).to be_between(0, 1) }
        it { expect(color['hue']).to be_kind_of(Float) }
        it { expect(color['saturation']).to be_kind_of(Float) }
        it { expect(color['brightness']).to be_kind_of(Float) }
      end
    end
  end

  context 'when adding a new color' do
    context 'when is valid' do
      subject(:color_adding) { described_instance << valid_color }

      it { expect { color_adding }.to change { described_instance.colors.size }.by(1) }
      it { is_expected.to be_kind_of(Array) }
    end

    context 'when is invalid' do
      subject(:color_adding) { described_instance << invalid_colors.sample }

      it { expect { color_adding }.not_to(change { described_instance.colors.size }) }
      it { is_expected.to be_kind_of(Array) }
      it { is_expected.to eq(initial_wrapper_colors) }
    end
  end

  context 'when removing a color' do
    it { expect { described_instance.pop }.to change { described_instance.colors.size }.by(-1) }
  end

  context 'when exporting swatches to file' do
    subject { described_instance.to_file }

    it { is_expected.to be_kind_of(String) }
    it { is_expected.to include(described_instance.name) }
  end
end
