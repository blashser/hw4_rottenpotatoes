require 'spec_helper'

describe Movie do
  describe 'Get all ratings' do
    it 'should get all available rating' do
      answer = %w( G PG PG-13 NC-17 R )
      Movie.all_ratings.should == answer
    end
  end
end

