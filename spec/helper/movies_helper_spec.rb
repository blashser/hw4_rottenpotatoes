require 'spec_helper'

class DummyClass
end

describe MoviesHelper do
  describe 'handling oddness' do
    it 'gets odd' do
      m = DummyClass.new
      m.extend( MoviesHelper )
      m.oddness( 3 ).should == "odd"
    end

    it 'gets even' do
      m = DummyClass.new
      m.extend MoviesHelper
      m.oddness( 4 ).should == "even"
    end
  end
end
