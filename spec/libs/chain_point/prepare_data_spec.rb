require 'spec_helper'

RSpec.describe ChainPoint::PrepareData do
  let(:params) { { issue_date: '2021-08-20', recipient_name: 'Test Name', uuid: 'Test UUID' } }

  subject { described_class }

  context '.call' do
    it 'should rise NotImplementedError exception' do
      expect { subject.call(params) }.to raise_exception(NotImplementedError)
    end
  end
end
