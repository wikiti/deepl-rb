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
        DeepL::Configuration.new(auth_key: 'VALID', host: 'http://www.example.org')
      end
      before do
        subject.configure do |config|
          config.auth_key = configuration.auth_key
          config.host = configuration.host
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
      VCR.use_cassette('deepl_translate') { example.call }
    end

    context 'When translating a text' do
      it 'should create and call a request object' do
        expect(DeepL::Requests::TranslateText).to receive(:new)
          .with(subject.api, input, source_lang, target_lang, options).and_call_original

        text = subject.translate(input, source_lang, target_lang, options)
        expect(text).to be_a(DeepL::Resources::Text)
      end
    end
  end
end
