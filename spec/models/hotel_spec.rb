require 'rails_helper'

describe Hotel do
  it 'gives lists of hotel with given location details' do
    result = Hotel.get_hotels_by_location(nil, nil)

    expect(result['results'].first['name']).to be_truthy
  end
end
