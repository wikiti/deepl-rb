# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::Glossary::LanguagePairs do
  let(:api) { build_deepl_api }
  let(:options) { {} }
  subject { DeepL::Requests::Glossary::LanguagePairs.new(api, options) }

  describe '#initialize' do
    context 'When building a request' do
      it 'should create a request object' do
        expect(subject).to be_a(described_class)
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('glossaries') { example.call }
    end

    context 'When requesting a list of all language pairs supported by glossaries' do
      it 'should return a language pairs object' do
        language_pairs = subject.request
        expect(language_pairs).to be_an(Array)
      end
    end
  end
end
