RSpec.describe Api::V1::PerformanceDataController, type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:another_user) {FactoryBot.create(:user, email: 'another@example.com') }
  let(:credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
  let(:headers_wo_credentials) { { HTTP_ACCEPT: 'application/json' } }


  describe 'POST /api/v1/performance_data' do
    it 'creates a data entry' do
      post '/api/v1/performance_data', params: { performance_data: { data: { message: 'Average' } }
      }, headers: headers

      entry = PerformanceData.last
      expect(entry.data).to eq 'message' => 'Average'
      expect(response_json['message']).to eq 'all good'
    end
  
    it 'fails to create entry without credentials' do
      post '/api/v1/performance_data', params: { performance_data: { data: { message: 'Average' } }
      }, headers: headers_wo_credentials
    
      expect(response_json['errors']).to eq ['You need to sign in or sign up before continuing.']
    end  

    it 'fails to create entry when no user exists' do
      no_user = PerformanceData.create(data: {message: "Average"})
      expect(no_user.errors.full_messages).to eq ['User must exist']
    end
  end

  describe 'GET /api/v1/performance_data' do
    before do
      5.times { user.performance_data.create(data: { message: 'Average' }) }
      10.times { another_user.performance_data.create(data: { message: 'Below average'})}
    end
  
    it 'returns a collection of performance data for only current user' do
      get '/api/v1/performance_data', headers: headers
      expect(response_json['entries'].count).to eq 5
    end
  end

end