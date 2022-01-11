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

      it 'should not include the supports formality attribute' do
        expect(subject.respond_to?(:supports_formality)).to eq(false)
        expect { subject.supports_formality }.to raise_error(NoMethodError)
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
        expect(subject.supports_formality).to eq(true)
      end

      it 'should include the supports formality attribute' do
        expect(subject.respond_to?(:supports_formality)).to eq(true)
      end
    end
  end
end
