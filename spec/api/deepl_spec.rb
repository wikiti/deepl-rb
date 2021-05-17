# frozen_string_literal: true

require 'spec_helper'

describe DeepL do
  subject { DeepL.dup }

  describe '#configure' do
    context 'When providing no block' do
      let(:configuration) { DeepL::Configuration.new }
      before { subject.configure }

      it 'should use default configuration' do
        expect(subject.configuration).to eq(configuration)
      end
    end

    context 'When providing a valid configuration' do
      let(:configuration) do
        DeepL::Configuration.new(auth_key: 'VALID', host: 'http://www.example.org', version: 'v1')
      end
      before do
        subject.configure do |config|
          config.auth_key = configuration.auth_key
          config.host = configuration.host
          config.version = configuration.version
        end
      end

      it 'should use the provided configuration' do
        expect(subject.configuration).to eq(configuration)
      end
    end

    context 'When providing an invalid configuration' do
      it 'should raise an error' do
        expect { subject.configure { |c| c.auth_key = '' } }
          .to raise_error(DeepL::Exceptions::Error)
      end
    end
  end

  describe '#translate' do
    let(:input) { 'Sample' }
    let(:source_lang) { 'EN' }
    let(:target_lang) { 'ES' }
    let(:options) { { param: 'fake' } }

    around do |example|
      subject.configure { |config| config.host = 'https://api-free.deepl.com' }
      VCR.use_cassette('deepl_translate') { example.call }
    end

    context 'When translating a text' do
      it 'should create and call a request object' do
        expect(DeepL::Requests::Translate).to receive(:new)
          .with(subject.api, input, source_lang, target_lang, options).and_call_original

        text = subject.translate(input, source_lang, target_lang, options)
        expect(text).to be_a(DeepL::Resources::Text)
      end
    end
  end

  describe '#usage' do
    let(:options) { {} }

    around do |example|
      subject.configure { |config| config.host = 'https://api-free.deepl.com' }
      VCR.use_cassette('deepl_usage') { example.call }
    end

    context 'When checking usage' do
      it 'should create and call a request object' do
        expect(DeepL::Requests::Usage).to receive(:new)
          .with(subject.api, options).and_call_original

        usage = subject.usage(options)
        expect(usage).to be_a(DeepL::Resources::Usage)
      end
    end
  end

  describe '#languages' do
    let(:options) { { type: :target } }

    around do |example|
      subject.configure { |config| config.host = 'https://api-free.deepl.com' }
      VCR.use_cassette('deepl_languages') { example.call }
    end

    context 'When checking languages' do
      it 'should create and call a request object' do
        expect(DeepL::Requests::Languages).to receive(:new)
          .with(subject.api, options).and_call_original

        languages = subject.languages(options)
        expect(languages).to be_an(Array)
        expect(languages.all? { |l| l.is_a?(DeepL::Resources::Language) }).to be_truthy
      end
    end
  end
end
