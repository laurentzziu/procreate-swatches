# frozen_string_literal: true

RSpec.describe Procreate::Swatches do
  let(:swatches_file_name) { 'snowy_landscape_2.swatches' }
  let(:swatches_file_path) { path_for_file(swatches_file_name) }
  let(:name) { 'Spec Swatches' }
  let(:colors) { %w[#aaa #bbb] }

  context 'when calling #parse and #from_file (alias)' do
    it { expect(described_class).to respond_to(:parse).with(1).argument }
    it { expect(described_class).to respond_to(:from_file).with(1).argument }
    it { expect(described_class.parse(swatches_file_path)).to be_kind_of(Procreate::Swatches::Wrapper) }
  end

  context 'when calling #export and #to_file (alias)' do
    it { expect(described_class).to respond_to(:export).with(3).arguments }
    it { expect(described_class).to respond_to(:to_file).with(3).arguments }
    it { expect(described_class.export(name, colors)).to be_kind_of(String) }
    it { expect(described_class.export(name, colors)).to include(name) }
  end

  context 'when calling constants' do
    it { expect(described_class::SWATCHES_FILE_NAME).to eq('Swatches.json') }
  end
end
