# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::Glossary::List do
  let(:api) { build_deepl_api }
  let(:options) { {} }
  subject { DeepL::Requests::Glossary::List.new(api, options) }

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

    context 'When requesting a list of all glossaries' do
      it 'should return a glossaries object' do
        glossaries = subject.request
        expect(glossaries).to be_an(Array)
      end
    end

    context 'When performing a bad request' do
      context 'When using an invalid token' do
        let(:api) do
          api = build_deepl_api
          api.configuration.auth_key = 'invalid'
          api
        end

        it 'should raise an unauthorized error' do
          expect { subject.request }.to raise_error(DeepL::Exceptions::AuthorizationFailed)
        end
      end
    end
  end
end
