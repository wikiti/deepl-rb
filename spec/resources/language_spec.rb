# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Resources::Language do
  subject { described_class.new('EN', 'English', nil, nil, nil) }

  describe '#initialize' do
    context 'When building a basic object' do
      it 'should create a resource' do
        expect(subject).to be_a(described_class)
      end

      it 'should assign the attributes' do
        expect(subject.code).to eq('EN')
        expect(subject.name).to eq('English')
      end

      it 'should not define the supports formality method' do
        expect { subject.supports_formality? }.to raise_error(DeepL::Exceptions::NotSupported)
      end
    end

    context 'when building a target language object' do
      subject { described_class.new('EN', 'English', true, nil, nil) }

      it 'should create a resource' do
        expect(subject).to be_a(described_class)
      end

      it 'should assign the attributes' do
        expect(subject.code).to eq('EN')
        expect(subject.name).to eq('English')
      end

      it 'should include the supports formality method' do
        expect { subject.supports_formality? }.not_to raise_error
        expect(subject.supports_formality?).to be_truthy
      end
    end
  end
end
