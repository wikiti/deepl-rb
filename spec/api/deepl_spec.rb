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

    context 'When translating a text using a glossary' do
      before(:each) do
        @glossary = subject.glossaries.create('fixture', 'EN', 'ES', [%w[car auto]])
      end
      let(:input) { 'I wish we had a car.' }
      let(:options) { { glossary_id: @glossary.id } }

      it 'should create and call a request object' do
        expect(DeepL::Requests::Translate).to receive(:new)
          .with(subject.api, input, source_lang, target_lang, options).and_call_original
        text = subject.translate(input, source_lang, target_lang, options)
        expect(text).to be_a(DeepL::Resources::Text)
        expect(text.text).to eq('Ojalá tuviéramos un auto.')
      end

      after(:each) do
        subject.glossaries.destroy(@glossary.id)
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

  describe '#glossaries' do
    describe '#glossaries.create' do
      let(:name) { 'Mi Glosario' }
      let(:source_lang) { 'EN' }
      let(:target_lang) { 'ES' }
      let(:entries) do
        [
          %w[Hello Hola],
          %w[World Mundo]
        ]
      end
      let(:entries_format) { 'tsv' }
      let(:options) { { param: 'fake' } }

      around do |example|
        subject.configure { |config| config.host = 'https://api-free.deepl.com' }
        VCR.use_cassette('deepl_glossaries') { example.call }
      end

      context 'When creating a glossary' do
        it 'should create and call a request object' do
          expect(DeepL::Requests::Glossary::Create).to receive(:new)
            .with(subject.api, name, source_lang, target_lang, entries, entries_format,
                  options).and_call_original

          glossary = subject.glossaries.create(name, source_lang, target_lang, entries,
                                               entries_format, options)
          expect(glossary).to be_a(DeepL::Resources::Glossary)
        end
      end
    end

    describe '#glossaries.find' do
      let(:id) { 'd9ad833f-c818-430c-a3c9-47071384fa3e' }
      let(:options) { {} }

      around do |example|
        subject.configure { |config| config.host = 'https://api-free.deepl.com' }
        VCR.use_cassette('deepl_glossaries') { example.call }
      end

      context 'When fetching a glossary' do
        it 'should create and call a request object' do
          expect(DeepL::Requests::Glossary::Find).to receive(:new)
            .with(subject.api, id, options).and_call_original

          glossary = subject.glossaries.find(id, options)
          expect(glossary).to be_a(DeepL::Resources::Glossary)
        end
      end

      context 'When fetching a non existing glossary' do
        let(:id) { '00000000-0000-0000-0000-000000000000' }

        it 'should raise an exception when the glossary does not exist' do
          expect(DeepL::Requests::Glossary::Find).to receive(:new)
            .with(subject.api, id, options).and_call_original
          expect { subject.glossaries.find(id, options) }
            .to raise_error(DeepL::Exceptions::NotFound)
        end
      end
    end

    describe '#glossaries.list' do
      let(:options) { {} }

      around do |example|
        subject.configure { |config| config.host = 'https://api-free.deepl.com' }
        VCR.use_cassette('deepl_glossaries') { example.call }
      end

      context 'When fetching glossaries' do
        it 'should create and call a request object' do
          expect(DeepL::Requests::Glossary::List).to receive(:new)
            .with(subject.api, options).and_call_original

          glossaries = subject.glossaries.list(options)
          expect(glossaries).to all(be_a(DeepL::Resources::Glossary))
        end
      end
    end

    describe '#glossaries.destroy' do
      let(:id) { 'd9ad833f-c818-430c-a3c9-47071384fa3e' }
      let(:options) { {} }

      around do |example|
        subject.configure { |config| config.host = 'https://api-free.deepl.com' }
        VCR.use_cassette('deepl_glossaries') { example.call }
      end

      context 'When destroy a glossary' do
        let(:new_glossary) do
          subject.glossaries.create('fixture', 'EN', 'ES', [%w[Hello Hola]])
        end
        it 'should create and call a request object' do
          expect(DeepL::Requests::Glossary::Destroy).to receive(:new)
            .with(subject.api, new_glossary.id, options).and_call_original

          glossary_id = subject.glossaries.destroy(new_glossary.id, options)
          expect(glossary_id).to eq(new_glossary.id)
        end
      end

      context 'When destroying a non existing glossary' do
        let(:id) { '00000000-0000-0000-0000-000000000000' }

        it 'should raise an exception when the glossary does not exist' do
          expect(DeepL::Requests::Glossary::Destroy).to receive(:new)
            .with(subject.api, id, options).and_call_original
          expect { subject.glossaries.destroy(id, options) }
            .to raise_error(DeepL::Exceptions::NotFound)
        end
      end
    end

    describe '#glossaries.entries' do
      let(:id) { '012a5576-b551-4d4c-b917-ce01bc8debb6' }
      let(:options) { {} }

      around do |example|
        subject.configure { |config| config.host = 'https://api-free.deepl.com' }
        VCR.use_cassette('deepl_glossaries') { example.call }
      end

      context 'When listing glossary entries' do
        it 'should create and call a request object' do
          expect(DeepL::Requests::Glossary::Entries).to receive(:new)
            .with(subject.api, id, options).and_call_original

          entries = subject.glossaries.entries(id, options)
          expect(entries).to all(be_a(Array))
          entries.each do |entry|
            expect(entry.size).to eq(2)
            expect(entry.first).to be_a(String)
            expect(entry.last).to be_a(String)
          end
        end
      end

      context 'When listing entries of a non existing glossary' do
        let(:id) { '00000000-0000-0000-0000-000000000000' }

        it 'should raise an exception when the glossary does not exist' do
          expect(DeepL::Requests::Glossary::Entries).to receive(:new)
            .with(subject.api, id, options).and_call_original
          expect { subject.glossaries.entries(id, options) }
            .to raise_error(DeepL::Exceptions::NotFound)
        end
      end
    end

    describe '#glossaries.language_pairs' do
      let(:options) { {} }

      around do |example|
        subject.configure { |config| config.host = 'https://api-free.deepl.com' }
        VCR.use_cassette('deepl_glossaries') { example.call }
      end

      context 'When fetching language pairs supported by glossaries' do
        it 'should create and call a request object' do
          expect(DeepL::Requests::Glossary::LanguagePairs).to receive(:new)
            .with(subject.api, options).and_call_original

          language_pairs = subject.glossaries.language_pairs(options)
          expect(language_pairs).to all(be_a(DeepL::Resources::LanguagePair))
        end
      end
    end
  end
end
