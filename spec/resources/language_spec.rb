# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Resources::Language do
  subject { described_class.new('EN', 'English', nil, nil) }

  describe '#initialize' do
    context 'When building a basic object' do
      it 'should create a resource' do
        expect(subject).to be_a(described_class)
      end

      it 'should assign the attributes' do
        expect(subject.code).to eq('EN')
        expect(subject.name).to eq('English')
      end
    end
  end
end
