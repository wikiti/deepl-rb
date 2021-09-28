# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Requests::Translate do
  let(:tags_str) { 'p, strong, span' }
  let(:tags_array) { %w[p strong span] }

  let(:api) { build_deepl_api }
  let(:text) { 'Sample text' }
  let(:source_lang) { 'EN' }
  let(:target_lang) { 'ES' }
  let(:options) { {} }
  subject { DeepL::Requests::Translate.new(api, text, source_lang, target_lang, options) }

  describe '#initialize' do
    context 'When building a request' do
      it 'should create a request object' do
        expect(subject).to be_a(DeepL::Requests::Translate)
      end
    end

    context 'when using `non_splitting_tags` options' do
      it 'should work with a nil values' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, non_splitting_tags: nil)
        expect(request.options[:non_splitting_tags]).to eq(nil)
      end

      it 'should work with a blank list' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, non_splitting_tags: '')
        expect(request.options[:non_splitting_tags]).to eq('')
      end

      it 'should work with a comma-separated list' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, non_splitting_tags: tags_str)
        expect(request.options[:non_splitting_tags]).to eq(tags_str)
      end

      it 'should convert arrays to strings' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, non_splitting_tags: tags_array)
        expect(request.options[:non_splitting_tags]).to eq(tags_str)
      end

      it 'should leave strings as they are' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, non_splitting_tags: tags_str)
        expect(request.options[:non_splitting_tags]).to eq(tags_str)
      end
    end

    context 'when using `ignore_tags` options' do
      it 'should work with a nil values' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, ignore_tags: nil)
        expect(request.options[:ignore_tags]).to eq(nil)
      end

      it 'should work with a blank list' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, ignore_tags: '')
        expect(request.options[:ignore_tags]).to eq('')
      end

      it 'should work with a comma-separated list' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, ignore_tags: tags_str)
        expect(request.options[:ignore_tags]).to eq(tags_str)
      end

      it 'should convert arrays to strings' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, ignore_tags: tags_array)
        expect(request.options[:ignore_tags]).to eq(tags_str)
      end

      it 'should leave strings as they are' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, ignore_tags: tags_str)
        expect(request.options[:ignore_tags]).to eq(tags_str)
      end
    end

    context 'when using `split_sentences` options' do
      it 'should convert `true` to `1`' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, split_sentences: true)
        expect(request.options[:split_sentences]).to eq('1')
      end

      it 'should convert `false` to `0`' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, split_sentences: false)
        expect(request.options[:split_sentences]).to eq('0')
      end

      it 'should leave `0` as is' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, split_sentences: '0')
        expect(request.options[:split_sentences]).to eq('0')
      end

      it 'should leave `nonewlines` as is' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, split_sentences: 'nonewlines')
        expect(request.options[:split_sentences]).to eq('nonewlines')
      end

      it 'should leave `1` as is' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, split_sentences: '1')
        expect(request.options[:split_sentences]).to eq('1')
      end
    end

    context 'when using `preserve_formatting` options' do
      it 'should convert `true` to `1`' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, preserve_formatting: true)
        expect(request.options[:preserve_formatting]).to eq('1')
      end

      it 'should convert `false` to `0`' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, preserve_formatting: false)
        expect(request.options[:preserve_formatting]).to eq('0')
      end

      it 'should leave `0` as is' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, preserve_formatting: '0')
        expect(request.options[:preserve_formatting]).to eq('0')
      end

      it 'should leave `1` as is' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, preserve_formatting: '1')
        expect(request.options[:preserve_formatting]).to eq('1')
      end
    end

    context 'when using `outline_detection` options' do
      it 'should convert `true` to `1`' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, outline_detection: true)
        expect(request.options[:outline_detection]).to eq('1')
      end

      it 'should convert `false` to `0`' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, outline_detection: false)
        expect(request.options[:outline_detection]).to eq('0')
      end

      it 'should leave `0` as is' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, outline_detection: '0')
        expect(request.options[:outline_detection]).to eq('0')
      end

      it 'should leave `1` as is' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, outline_detection: '1')
        expect(request.options[:outline_detection]).to eq('1')
      end
    end

    context 'when using `glossary_id` options' do
      it 'should work with a nil values' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, glossary_id: nil)
        expect(request.options[:glossary_id]).to eq(nil)
      end

      it 'should work with a string' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, glossary_id: 'sample_id')
        expect(request.options[:glossary_id]).to eq('sample_id')
      end
    end

    context 'when using `formality` options' do
      it 'should work with a nil values' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, formality: nil)
        expect(request.options[:formality]).to eq(nil)
      end

      it 'should work with a string' do
        request = DeepL::Requests::Translate.new(api, nil, nil, nil, formality: 'more')
        expect(request.options[:formality]).to eq('more')
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
      let(:options) { { tag_handling: 'xml' } }

      it 'should return a text object' do
        text = subject.request

        expect(text).to be_a(DeepL::Resources::Text)
        expect(text.text).to eq('<p>Texto de muestra</p>')
        expect(text.detected_source_language).to eq('EN')
      end
    end

    context 'When performing a valid request and passing a variable' do
      let(:text) { 'Welcome and <code>Hello great World</code> Good Morning!' }
      let(:options) { { tag_handling: 'xml', ignore_tags: 'code,span' } }

      it 'should return a text object' do
        text = subject.request

        expect(text).to be_a(DeepL::Resources::Text)
        expect(text.text).to eq('Bienvenido y <code>Hello great World</code> ¡Buenos días!')
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
          message = "Value for 'target_lang' not supported."
          expect { subject.request }.to raise_error(DeepL::Exceptions::BadRequest, message)
        end
      end
    end
  end
end
