require 'spec_helper'

RSpec.describe ChainPoint::ApiRequest::SubmitBadge do
  let(:params)            { { issue_date: '2021-08-20', recipient_name: 'Test Name', uuid: 'Test UUID' } }
  let(:prepared_data)     { { 'hashes': ['1957db7fe23e4be1740ddeb941ddda7ae0a6b782e536a9e00b5aa82db1e84547'] } }
  let(:response)          { YAML.load_file('spec/fixtures/chainpoint_submit_response.yml') }

  subject { described_class }

  describe 'private methods' do
    context '.post_data' do
      before do
        allow(HTTParty)
          .to receive(:post)
          .with(ENV['CHAINPOINT_API_URL'], body: prepared_data, headers: { 'Content-Type': 'application/json' })
          .and_return(response)
      end

      it 'should return response' do
        expect(subject.new(params).send(:post_data, prepared_data)).to eq(response)
      end
    end

    context '.log_error' do
      it 'should write error msg to log' do
        expect(Rails.logger).to receive(:info).with("Badge data with params #{params} was not submitted due to error: error")

        subject.new(params).send(:log_error, params, 'error')
      end
    end

    context '.log_success' do
      it 'should write success msg to log' do
        expect(Rails.logger)
          .to receive(:info)
          .with("Badge data with params #{params} was successfully submitted to url #{ENV['CHAINPOINT_API_URL']}")

        subject.new(params).send(:log_success, params)
      end
    end
  end

  context '.call' do
    subject { described_class.new(params) }

    before do
      allow(ChainPoint::PrepareData::ToSubmitBadge).to receive(:call).with(params).and_return(prepared_data)
    end

    it 'should log success message and return response' do
      allow(subject).to receive(:post_data).with(prepared_data).and_return(response)

      expect(subject).to receive(:log_success)

      expect(subject.call).to eq(response)
    end

    it 'should log error message' do
      allow(subject).to receive(:post_data).with(prepared_data).and_raise(StandardError.new('error'))

      expect(subject).to receive(:log_error)

      expect(subject.call).to eq({})
    end
  end
end
