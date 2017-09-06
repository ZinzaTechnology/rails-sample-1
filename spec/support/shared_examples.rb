# frozen_string_literal: true

shared_context 'show alert when user not logged in' do
  it 'should show alert' do
    expect(flash['alert']).to eq I18n.t('devise.failure.unauthenticated')
  end
end

shared_context 'response 401 when user not logged in' do
  it 'should response 401' do
    expect(response).to have_http_status 401
  end
end
