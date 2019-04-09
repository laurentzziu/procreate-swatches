# frozen_string_literal: true

class TestClass
  include Procreate::Swatches::ColorsHelper
end

RSpec.describe Procreate::Swatches::ColorsHelper do
  let(:test_class) { TestClass.new }
  let(:color_hex) { '#abc' }
  let(:invalid_color_hex) { 'zzz' }
  let(:chroma_color) { Chroma::Color.new(+color_hex) }
  let(:color_json) do
    {
      hue: 0.5833333333333334,
      saturation: 0.16666666666666677,
      brightness: 0.8,
      alpha: 1,
      colorSpace: 0
    }
  end

  context 'when testing #to_swatches_json' do
    it { expect(test_class).to respond_to(:to_swatches_json).with(1).argument }
    it { expect(test_class.to_swatches_json(chroma_color)).to eq(color_json) }
  end

  context 'when testing #to_chroma_hsv' do
    it { expect(test_class).to respond_to(:to_chroma_hsv).with(1).argument }
    it { expect(test_class.to_chroma_hsv(color_json.stringify_keys)).to eq("hsv(210, 17%, 80%)")}
  end

  context 'when testing #prepare_color_for_push' do
    it { expect(test_class).to respond_to(:prepare_color_for_push).with(1).argument }
    it { expect(test_class.prepare_color_for_push(chroma_color)).to be_instance_of(Chroma::Color) }
    it { expect(test_class.prepare_color_for_push(chroma_color)).to eq(chroma_color) }
    it { expect(test_class.prepare_color_for_push(invalid_color_hex)).to eq(nil) }
    it { expect(test_class.prepare_color_for_push(color_hex)).to eq(chroma_color) }
  end
end