# frozen_string_literal: true

require 'spec_helper'

describe DeepL::Configuration do
  let(:attributes) { {} }
  subject { DeepL::Configuration.new(attributes) }

  describe '#initialize' do
    context 'When using default configuration attributes' do
      it 'should use default attributes' do
        expect(subject.auth_key).to eq(ENV['DEEPL_AUTH_KEY'])
        expect(subject.host).to eq('https://api.deepl.com')
        expect(subject.version).to eq('v2')
      end
    end

    context 'When using custom configuration attributes' do
      let(:attributes) { { auth_key: 'SAMPLE', host: 'https://api-free.deepl.com', version: 'v1' } }

      it 'should use custom attributes' do
        expect(subject.auth_key).to eq(attributes[:auth_key])
        expect(subject.host).to eq(attributes[:host])
        expect(subject.version).to eq(attributes[:version])
      end
    end
  end

  describe '#validate!' do
    let(:auth_message) { 'auth_key not provided' }

    context 'When providing a valid auth key' do
      let(:attributes) { { auth_key: '' } }

      it 'should raise an error' do
        expect { subject.validate! }.to raise_error(DeepL::Exceptions::Error, auth_message)
      end
    end

    context 'When providing an invalid auth key' do
      let(:attributes) { { auth_key: 'not-empty' } }

      it 'should not raise an error' do
        expect { subject.validate! }.not_to raise_error
      end
    end
  end
end
