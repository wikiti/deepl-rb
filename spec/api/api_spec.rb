# frozen_string_literal: true

require 'spec_helper'

describe DeepL::API do
  let(:configuration) { DeepL::Configuration.new }
  subject { DeepL::API.new(configuration) }

  describe '#initialize' do
    context 'When building an API object' do
      it 'should save the configuration' do
        expect(subject.configuration).to be(configuration)
      end
    end
  end
end
