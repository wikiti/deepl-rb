# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::Glossary::Destroy do
  let(:api) { build_deepl_api }
  let(:id) { '367eef44-b533-4d95-be19-74950c7760e9' }
  subject { DeepL::Requests::Glossary::Destroy.new(api, id) }

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
      let(:new_glossary) do
        DeepL::Requests::Glossary::Create.new(api, 'fixture', 'EN', 'ES', [%w[Hello Holla]]).request
      end
      subject { DeepL::Requests::Glossary::Destroy.new(api, new_glossary.id) }
      it 'should return an empty object' do
        response = subject.request
        expect(response).to eq(new_glossary.id)
      end
    end

    context 'When deleting a non existing glossary with a valid id' do
      let(:id) { '00000000-0000-0000-0000-000000000000' }
      subject { DeepL::Requests::Glossary::Destroy.new(api, id) }
      it 'should raise a not found error' do
        expect { subject.request }.to raise_error(DeepL::Exceptions::NotFound)
      end
    end

    context 'When deleting a non existing glossary with an invalid id' do
      let(:id) { 'invalid-uuid' }
      subject { DeepL::Requests::Glossary::Destroy.new(api, id) }
      it 'should raise a bad request error' do
        expect { subject.request }.to raise_error(DeepL::Exceptions::BadRequest)
      end
    end
  end
end
