require 'spec_helper'

RSpec.describe ChainPoint::ApiRequest do
  let(:params) { { 'hashes': ['1957db7fe23e4be1740ddeb941ddda7ae0a6b782e536a9e00b5aa82db1e84547'] } }

  subject { described_class }

  context '.call' do
    it 'should rise NotImplementedError exception' do
      expect { subject.call(params) }.to raise_exception(NotImplementedError)
    end
  end
end
