require 'spec_helper'

describe MoviesController do
  describe 'find movie with same director' do
    it 'should call the model method that gets the list of movies with same director' do
      input = '33'
      output = mock( 'FakeMovie' )
      output.stub( :title ).and_return( "facebook" )
      output.stub( :director ).and_return( "mark" )
      Movie.should_receive( :find ).with( input ).and_return( output )
      Movie.should_receive( :find_all_by_director ).with( output.director )
      get :similarmovies , { :id => input }
    end
    it 'should select the Find Similar Movies templpate for rendering' do
      output = mock( 'FakeMovie' )
      output.stub( :title ).and_return( "facebook" )
      output.stub( :director ).and_return( "mark" )
      Movie.stub( :find ).with( '33' ).and_return( output )
      Movie.stub( :find_all_by_director ).with( output.director )
      get :similarmovies , { :id => '33' }
      response.should render_template( 'similarmovies' )
    end
    it 'should make the the search result available to that template' do
      fake_return = '42'
      output = mock( 'FakeMovie' )
      output.stub( :title ).and_return( "facebook" )
      output.stub( :director ).and_return( "mark" )
      Movie.stub( :find ).with( '33' ).and_return output
      Movie.stub( :find_all_by_director ).with( output.director ).and_return( fake_return )
      get :similarmovies , { :id => '33' }
      assigns( :movies ).should == fake_return
    end
    it 'should make to go to home page if director is not set' do
      fake_return = '42'
      output = mock( 'FakeMovie' )
      output.stub( :title ).and_return( "facebook" )
      output.stub( :director ).and_return( "" )
      Movie.stub( :find ).with( '33' ).and_return output
      get :similarmovies , { :id => '33' }
      response.should redirect_to movies_path
    end
  end
end

