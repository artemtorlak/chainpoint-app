require 'spec_helper'

RSpec.describe ChainPoint::PrepareData::ToSubmitBadge do
  let(:params)        { { unnecessary_data: 'test', issue_date: '2021-08-20', recipient_name: 'Test Name', uuid: 'Test UUID' } }
  let(:badge_data)    { params.except(:unnecessary_data).to_s }
  let(:sha)           { '2d11f46eeb1b8581a04879e2d9147b93836cd227f22b682775e76e21dcca2690' }
  let(:prepared_data) { { 'hashes': [sha] }.to_json }

  subject { described_class.new(params) }

  describe 'private methods' do
    let(:badge_data) { params.except(:unnecessary_data).to_s }

    context '.get_neccessary_params' do
      it 'should take only necessary params' do
        expect(subject.send(:get_neccessary_params)).to eq(badge_data)
      end
    end

    context '.create_sha' do
      it 'should create sha from data' do
        expect(subject.send(:create_sha, badge_data)).to eq(sha)
      end
    end

    context '.create_hash' do
      it 'should return right structure hash' do
        result = subject.send(:create_hash, sha)

        expect(result).to eq(prepared_data)
      end
    end
  end

  context '.call' do
    before do
      allow(subject).to receive(:get_neccessary_params).and_return(badge_data)
      allow(subject).to receive(:create_sha).with(badge_data).and_return(sha)
      allow(subject).to receive(:create_hash).with(sha).and_return(prepared_data)
    end

    it 'should call get_neccessary_params, create_sha, create_hash functions' do
      expect(subject).to receive(:get_neccessary_params)
      expect(subject).to receive(:create_sha)
      expect(subject).to receive(:create_hash)

      expect(subject.call).to eq(prepared_data)
    end
  end
end
