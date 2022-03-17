# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::Glossary::Create do
  let(:api) { build_deepl_api }
  let(:name) { 'Mi Glosario' }
  let(:source_lang) { 'EN' }
  let(:target_lang) { 'ES' }
  let(:entries) do
    [
      %w[Hello Hola],
      %w[World Mundo]
    ]
  end
  let(:entries_format) { 'tsv' }
  let(:options) { {} }
  subject do
    DeepL::Requests::Glossary::Create.new(api, name, source_lang, target_lang, entries, options)
  end

  describe '#initialize' do
    context 'When building a request' do
      it 'should create a request object' do
        expect(subject).to be_a(described_class)
      end

      it 'should set the default value for the entries format if not specified' do
        request = DeepL::Requests::Glossary::Create.new(api, name, source_lang, target_lang,
                                                        entries, options)
        expect(request.entries_format).to eq('tsv')
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('glossaries') { example.call }
    end

    context 'When performing a valid request with two glossary entries' do
      it 'should return a glossaries object' do
        glossary = subject.request
        expect(glossary).to be_a(DeepL::Resources::Glossary)
        expect(glossary.id).to be_kind_of(String)
        expect(glossary.name).to eq('Mi Glosario')
        expect(glossary.ready).to be(true).or be(false)
        expect(glossary.source_lang).to eq('en')
        expect(glossary.target_lang).to eq('es')
        expect { Time.iso8601(glossary.creation_time) }.not_to raise_error
        expect(glossary.entry_count).to eq(2)
      end
    end
  end
end
