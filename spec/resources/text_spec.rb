require 'spec_helper'

describe DeepL::Resources::Text do
  subject { DeepL::Resources::Text.new('Target', 'es', nil, nil) }

  describe '#initialize' do
    context 'When building a basic object' do
      it 'should create a resource' do
        expect(subject).to be_a(DeepL::Resources::Text)
      end

      it 'should assign the attributes' do
        expect(subject.text).to eq('Target')
        expect(subject.detected_source_language).to eq('es')
      end
    end
  end
end
