# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::Glossary::Entries do
  let(:api) { build_deepl_api }
  let(:id) { '012a5576-b551-4d4c-b917-ce01bc8debb6' }
  subject { DeepL::Requests::Glossary::Entries.new(api, id) }

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
      it 'should return a list of entries in TSV format' do
        entries = subject.request
        expect(entries).to be_kind_of(Array)
        expect(entries).to all(be_a(Array))
        expect(entries.size).to eq(2)
      end
    end

    context 'When requesting entries with a valid but non existing glossary id' do
      let(:id) { '00000000-0000-0000-0000-000000000000' }
      subject { DeepL::Requests::Glossary::Entries.new(api, id) }
      it 'should raise a not found error' do
        expect { subject.request }.to raise_error(DeepL::Exceptions::NotFound)
      end
    end

    context 'When requesting entries with an invalid glossary id' do
      let(:id) { 'invalid-uuid' }
      subject { DeepL::Requests::Glossary::Entries.new(api, id) }
      it 'should raise a bad request error' do
        expect { subject.request }.to raise_error(DeepL::Exceptions::BadRequest)
      end
    end
  end
end
