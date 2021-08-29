require 'spec_helper'

RSpec.describe BadgesController, type: :controller do
  let(:params)          { { unnecessary_data: 'test', issue_date: '2021-08-20', recipient_name: 'Test Name', uuid: 'Test UUID' } }
  let(:submit_response) { YAML.load_file('spec/fixtures/chainpoint_submit_response.yml').with_indifferent_access }

  subject { described_class.new(params) }

  context 'new' do
    render_views

    it 'has a widgets related heading' do
      get :new

      expect(response.content_type).to eq('text/html; charset=utf-8')
      expect(response.body).to match(/Submit Badge/)
    end
  end

  context 'submit_to_chainpoint' do
    context 'success' do
      before do
        allow(ChainPoint::ApiRequest::SubmitBadge).to receive(:call).and_return(submit_response)
      end

      it 'should redirect to success action' do
        post :submit_to_chainpoint, params: params

        expect(response).to redirect_to action: :success, badge_hashes: submit_response[:hashes]
      end
    end

    context 'wrong response' do
      before do
        allow(ChainPoint::ApiRequest::SubmitBadge).to receive(:call).and_return(submit_response.except(:hashes))
      end

      it 'should redirect to error action' do
        post :submit_to_chainpoint, params: params

        expect(response).to redirect_to action: :error
      end
    end
  end
end
