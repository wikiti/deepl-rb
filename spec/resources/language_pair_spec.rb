# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Resources::LanguagePair do
  subject { described_class.new('en', 'de', nil, nil) }

  describe '#initialize' do
    context 'When building a basic object' do
      it 'should create a resource' do
        expect(subject).to be_a(described_class)
      end

      it 'should assign the attributes' do
        expect(subject.source_lang).to eq('en')
        expect(subject.target_lang).to eq('de')
      end
    end
  end
end
