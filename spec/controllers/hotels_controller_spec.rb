require 'rails_helper'
require 'helpers/checkin_creation_helper'

RSpec.configure do |config|
  config.include CheckinCreationHelper
end

describe HotelsController, type: :controller do
  it 'performs search and get results based on the request location' do
    do_sign_in

    result = get(:search, params: {search_key: ''})

    expect( JSON.parse(result.body)['hotels'].first['name']).to be_truthy
  end
end
