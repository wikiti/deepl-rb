require 'spec_helper'

describe DeepL::Requests::TranslateText do
  let(:api) { build_deepl_api }
  let(:text) { 'Sample text' }
  let(:source_lang) { 'EN' }
  let(:target_lang) { 'ES' }
  subject { DeepL::Requests::TranslateText.new(api, text, source_lang, target_lang) }

  describe '#initialize' do
    context 'When building a request' do
      it 'should create a request object' do
        expect(subject).to be_a(DeepL::Requests::TranslateText)
      end
    end
  end

  describe '#request' do
    around do |example|
      VCR.use_cassette('translate_texts') { example.call }
    end

    context 'When performing a valid request with one text' do
      it 'should return a text object' do
        text = subject.request

        expect(text).to be_a(DeepL::Resources::Text)
        expect(text.text).to eq('Texto de muestra')
        expect(text.detected_source_language).to eq('EN')
      end
    end

    context 'When performing a valid request with multiple texts' do
      let(:text) { %w[Sample Word] }

      it 'should return a text object' do
        texts = subject.request

        expect(texts).to be_a(Array)
        expect(texts.first.text).to eq('Muestra')
        expect(texts.first.detected_source_language).to eq('EN')

        expect(texts.last.text).to eq('Palabra')
        expect(texts.last.detected_source_language).to eq('EN')
      end
    end

    context 'When performing a valid request with tag handling' do
      let(:text) { '<p>Sample text</p>' }

      it 'should return a text object' do
        text = subject.request

        expect(text).to be_a(DeepL::Resources::Text)
        expect(text.text).to eq('<p>Texto de muestra</p>')
        expect(text.detected_source_language).to eq('EN')
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

      context 'When using an invalid text' do
        let(:text) { nil }

        it 'should raise a bad request error' do
          message = "Parameter 'text' not specified."
          expect { subject.request }.to raise_error(DeepL::Exceptions::BadRequest, message)
        end
      end

      context 'When using an invalid target language' do
        let(:target_lang) { nil }

        it 'should raise a bad request error' do
          message = "Parameter 'target_lang' not specified."
          expect { subject.request }.to raise_error(DeepL::Exceptions::BadRequest, message)
        end
      end
    end
  end
end
