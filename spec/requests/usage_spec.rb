# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::Usage do
  let(:api) { build_deepl_api }
  let(:options) { {} }
  subject { DeepL::Requests::Usage.new(api, options) }

  describe '#initialize' do
    context 'When building a request' do
      it 'should create a request object' do
        expect(subject).to be_a(DeepL::Requests::Usage)
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('usage') { example.call }
    end

    context 'When performing a valid request' do
      it 'should return an usage object' do
        usage = subject.request

        expect(usage).to be_a(DeepL::Resources::Usage)
        expect(usage.character_count).to be_a(Numeric)
        expect(usage.character_limit).to be_a(Numeric)
      end
    end
  end
end
