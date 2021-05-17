# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::Languages do
  let(:api) { build_deepl_api }
  let(:options) { {} }
  subject { DeepL::Requests::Languages.new(api, options) }

  describe '#initialize' do
    context 'When building a request' do
      it 'should create a request object' do
        expect(subject).to be_a(described_class)
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('languages') { example.call }
    end

    context 'When requesting source languages' do
      it 'should return an usage object' do
        languages = subject.request

        expect(languages).to be_an(Array)
        expect(languages.size).to eq(24)
        expect(languages.any? { |l| l.code == 'EN' && l.name == 'English' }).to be_truthy
        expect(languages.any? { |l| l.code == 'ES' && l.name == 'Spanish' }).to be_truthy
      end
    end

    context 'When requesting target languages' do
      let(:options) { { type: :target } }

      it 'should return an usage object' do
        languages = subject.request

        expect(languages).to be_an(Array)
        expect(languages.size).to eq(26)
        expect(languages.any? { |l| l.code == 'EN' && l.name == 'English' }).to be_falsey
        expect(languages.any? { |l| l.code == 'ES' && l.name == 'Spanish' }).to be_truthy
        expect(languages.any? { |l| l.code == 'EN-US' && l.name == 'English (American)' })
          .to be_truthy
      end
    end

    context 'When using an invalid type' do
      let(:options) { { type: :invalid } }

      it 'should return an usage object' do
        message = "Parameter 'type' is invalid. 'source' and 'target' are valid values."
        expect { subject.request }.to raise_error(DeepL::Exceptions::BadRequest, message)
      end
    end
  end
end
