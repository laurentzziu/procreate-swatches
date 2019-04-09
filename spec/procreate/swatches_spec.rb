# frozen_string_literal: true

RSpec.describe Procreate::Swatches do
  context 'when calling #parse and #from_file (alias)' do
    it { expect(described_class).to respond_to(:parse).with(1).argument }
    it { expect(described_class).to respond_to(:from_file).with(1).argument }
  end

  context 'when calling #export and #to_file (alias)' do
    it { expect(described_class).to respond_to(:export).with(3).arguments }
    it { expect(described_class).to respond_to(:to_file).with(3).arguments }
  end

  context 'when calling constants' do
    it { expect(described_class::SWATCHES_FILE_NAME).to eq('Swatches.json') }
  end
end
