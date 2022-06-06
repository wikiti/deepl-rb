# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::Glossary::Find do
  let(:api) { build_deepl_api }
  let(:id) { 'd9ad833f-c818-430c-a3c9-47071384fa3e' }
  let(:options) { {} }
  subject { DeepL::Requests::Glossary::Find.new(api, id, options) }

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

    context 'When performing a valid request' do
      it 'should return a glossary object' do
        glossary = subject.request
        expect(glossary).to be_a(DeepL::Resources::Glossary)
        expect(glossary.id).to eq('d9ad833f-c818-430c-a3c9-47071384fa3e')
        expect(glossary.name).to eq('Mi Glosario')
        expect(glossary.ready).to be(true).or be(false)
        expect(glossary.source_lang).to eq('en')
        expect(glossary.target_lang).to eq('es')
        expect { Time.iso8601(glossary.creation_time) }.not_to raise_error
        expect(glossary.entry_count).to eq(2)
      end
    end

    context 'When requesting a non existing glossary with a valid id' do
      let(:id) { 'a0af40e1-d81b-4aab-a95c-7cafbcfd1eb1' }
      subject { DeepL::Requests::Glossary::Find.new(api, id, options) }
      it 'should raise a not found error' do
        expect { subject.request }.to raise_error(DeepL::Exceptions::NotFound)
      end
    end

    context 'When requesting a non existing glossary with an invalid id' do
      let(:id) { 'invalid-uuid' }
      subject { DeepL::Requests::Glossary::Find.new(api, id, options) }
      it 'should raise a bad request error' do
        expect { subject.request }.to raise_error(DeepL::Exceptions::BadRequest)
      end
    end
  end
end
