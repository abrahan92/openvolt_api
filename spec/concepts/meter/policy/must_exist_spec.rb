# spec/concepts/meter/policy/must_exist_spec.rb

RSpec.describe Meter::Policy::MustExist do
  describe '.call' do
    let(:params) { { meter_id: '12345' } }
    let(:options) { {} }

    let(:fake_url) { "https://fake.openbolt.uri/v1/meters/#{params[:meter_id]}" }
    let(:fake_headers) { { "x-api-key" => "fake_openbolt_api_key" } }

    subject(:policy_result) do
      described_class.call(options, params: params)
    end

    before do
      allow(Settings.meter).to receive(:openbolt_uri).and_return('https://fake.openbolt.uri')
      allow(Settings.meter).to receive(:openbolt_api_key).and_return('fake_openbolt_api_key')
    end

    context 'when meter exists' do
      before do
        stub_request(:get, fake_url)
          .with(headers: fake_headers)
          .to_return(status: 200, body: { data: { exists: true } }.to_json)
      end

      it 'returns true' do
        expect(policy_result).to be true
      end
    end

    context 'when meter does not exist' do
      before do
        stub_request(:get, fake_url)
          .with(headers: fake_headers)
          .to_return(status: 404)
      end

      it 'returns false' do
        expect(policy_result).to be false
      end
    end

    context 'when there is an exception (e.g., network error)' do
      before do
        stub_request(:get, fake_url)
          .with(headers: fake_headers)
          .to_raise(StandardError)
      end

      it 'returns false' do
        expect(policy_result).to be false
      end
    end
  end
end
