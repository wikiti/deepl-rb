# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Resources::Glossary do
  subject do
    described_class.new('def3a26b-3e84-45b3-84ae-0c0aaf3525f7', 'Mein Glossar', true, 'EN', 'DE',
                        '2021-08-03T14:16:18.329Z', 1, nil, nil)
  end

  describe '#initialize' do
    context 'When building a basic object' do
      it 'should create a resource' do
        expect(subject).to be_a(described_class)
      end

      it 'should assign the attributes' do
        expect(subject.id).to eq('def3a26b-3e84-45b3-84ae-0c0aaf3525f7')
        expect(subject.name).to eq('Mein Glossar')
        expect(subject.ready).to eq(true)
        expect(subject.source_lang).to eq('EN')
        expect(subject.target_lang).to eq('DE')
        expect(subject.creation_time).to eq('2021-08-03T14:16:18.329Z')
        expect(subject.entry_count).to eq(1)
      end
    end
  end
end
