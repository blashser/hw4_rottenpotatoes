require 'spec_helper'

describe MoviesController do
  describe 'show a movie ' do
    it 'should call the model method that find the movie' do
      Movie.should_receive( :find ).with( "33" )
      get :show, { :id => "33" }
    end
    it 'should render template' do
      Movie.stub( :find ).with( "33" )
      get :show, { :id => "33" }
      response.should render_template 'show'
    end
    it 'should save in result in an instance variable available to that template' do
      mov = mock( 'movie' )
      Movie.stub( :find ).with( "33" ).and_return( mov )
      get :show, { :id => "33" }
      assigns( :movie ).should == mov
    end
  end

  describe 'update a movie ' do
    it 'should call the model method that find the movie' do
      mov = mock( 'movie', { :title =>"name_of_movie", :update_attributes! => "actualiza!" } )
      Movie.should_receive( :find ).with( "33" ).and_return mov
      get :update, { :id => "33", :movie =>"update_movie" }
    end
    it 'should render not template' do
      mov = mock( 'movie', { :title =>"name_of_movie", :update_attributes! => "actualiza!" } )
      Movie.stub( :find ).with( "33" ).and_return mov
      get :update, { :id => "33", :movie =>"update_movie" }
      response.should_not render_template 'update'
    end
    it 'should save in result in an instance variable available to that template' do
      mov = mock( 'movie', { :title =>"name_of_movie", :update_attributes! => "actualiza!" } )
      Movie.stub( :find ).with( "33" ).and_return( mov )
      get :update, { :id => "33", :movie =>"update_movie" }
      assigns( :movie ).should == mov
    end
    it 'should redirect to movies path' do
      mov = mock( 'movie', { :title =>"name_of_movie", :update_attributes! => "actualiza!" } )
      Movie.should_receive( :find ).with( "33" ).and_return( mov )
      post :update, { :id => "33", :movie =>"update_movie" }
      response.should redirect_to movie_path( mov )
    end
  end

  describe 'create a new movie' do
    it 'should call the model method that creates the movie' do
      mov = mock( 'movie', :title =>"name_of_movie" )
      Movie.should_receive( :create! ).with( "new movie" ).and_return( mov )
      post :create, { :movie => "new movie" }
    end
    it 'should save in instance variable' do
      mov = mock( 'movie', :title =>"name_of_movie" )
      Movie.stub( :create! ).with( "new movie" ).and_return( mov )
      post :create, { :movie => "new movie" }
      assigns( :movie ).should == mov
    end
    it 'should not render' do
      mov = mock( 'movie', :title =>"name_of_movie" )
      Movie.should_receive( :create! ).with( "new movie" ).and_return( mov )
      post :create, { :movie => "new movie" }
      response.should_not render_template 'create'
    end
    it 'should redirect to movies path' do
      mov = mock( 'movie', :title =>"name_of_movie" )
      Movie.should_receive( :create! ).with( "new movie" ).and_return( mov )
      post :create, { :movie => "new movie" }
      response.should redirect_to movies_path
    end
  end

  describe 'edit a movie ' do
    it 'should call the model method that find the movie' do
      Movie.should_receive( :find ).with( "33" )
      get :edit, { :id => "33" }
    end
    it 'should render template' do
      Movie.stub( :find ).with( "33" )
      get :edit, { :id => "33" }
      response.should render_template 'edit'
    end
    it 'should save in result in an instance variable available to that template' do
      mov = mock( 'movie', :title =>"name_of_movie" )
      Movie.stub( :find ).with( "33" ).and_return( mov )
      get :edit, { :id => "33" }
      assigns( :movie ).should == mov
    end
  end

  describe 'remove a movie ' do
    it 'should call the model method that find the movie' do
      mov = mock( 'movie', { :title =>"name_of_movie", :destroy => "muere" } )
      Movie.should_receive( :find ).with( "33" ).and_return mov
      get :destroy, { :id => "33" }
    end
    it 'should not render template' do
      mov = mock( 'movie', { :title =>"name_of_movie", :destroy => "muere" } )
      Movie.stub( :find ).with( "33" ).and_return mov
      get :destroy, { :id => "33" }
      response.should_not render_template 'destroy'
    end
    it 'should save in result in an instance variable available to destroy' do
      mov = mock( 'movie', { :title =>"name_of_movie", :destroy => "muere" } )
      Movie.stub( :find ).with( "33" ).and_return( mov )
      get :destroy, { :id => "33" }
      assigns( :movie ).should == mov
    end
    it 'should redirect to movies path' do
      mov = mock( 'movie', { :title =>"name_of_movie", :destroy => "muere" } )
      Movie.stub( :find ).with( "33" ).and_return( mov )
      get :destroy, { :id => "33" }
      response.should redirect_to movies_path
    end
  end

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

  describe 'index home page' do
    it 'should call the model method that gets all ratings' do
      Movie.should_receive( :all_ratings ).and_return( ["a", "x", "i"] )
      get :index, { :sort => "name movie", :ratings =>"adult" }
    end
    it 'should write in variables available for template' do
      get :index, { :sort => "release_date", :ratings =>"adult" }
      assigns( :date_header ).should == "hilite"
    end
    it 'should write in variables available for template' do
      get :index, { :sort => "title", :ratings =>"adult" }
      assigns( :title_header ).should == "hilite"
    end
    it 'should write in variables available for template' do
      array = ["a", "x", "i"]
      Movie.stub( :all_ratings ).and_return( array )
      get :index, { :sort => "name movie" }
      assigns( :selected_ratings ).should == Hash[ array.map {|rating| [rating, rating]} ]
    end
    it 'should write in variables available for template' do
      array = ["a", "x", "i"]
      Movie.stub( :all_ratings ).and_return( array )
      session[ :rating ] = "no_adult"
      get :index, { :sort => "title", :ratings =>"adult" }
      session[ :sort ].should == "title"
    end
    it 'should call the model method that gets all movies' do
      array = ["a", "x", "i"]
      mov = mock( 'movie', :title =>"name_of_movie" )
      Movie.stub( :all_ratings ).and_return( array )
      Movie.should_receive( :find_all_by_rating ).with( array, nil ).and_return( mov )
      get :index
    end
    it 'should save in instance variable' do
      mov = mock( 'movie', :title =>"name_of_movie" )
      Movie.stub( :all_ratings ).and_return( ["a", "x", "i"] )
      Movie.stub( :find_all_by_rating ).and_return( mov )
      get :index
      assigns( :movies ).should == mov
    end
    it 'should not render' do
      mov = mock( 'movie', :title =>"name_of_movie" )
      Movie.stub( :all_ratings ).and_return( ["a", "x", "i"] )
      get :index, { :sort => "name movie", :ratings =>"adult" }
      response.should_not render_template 'index'
    end
    it 'should redirect way1 to movies_path' do
      mov = mock( 'movie', :title =>"name_of_movie" )
      Movie.stub( :all_ratings ).and_return( ["a", "x", "i"] )
      get :index, { :sort => "name movie", :ratings =>"adult" }
      response.should redirect_to movies_path :sort => "name movie", :ratings =>"adult"
    end


    it 'should update session' do
      mov = mock( 'movie', :title =>"name_of_movie" )
      array = ["a", "x", "i"]
      Movie.stub( :all_ratings ).and_return( array )
      session[ :ratings ] = "no_adult"
      get :index, { :ratings =>"adult" }
      session[ :ratings ].should == "adult"
    end
    it 'should redirect way2 to movies_path' do
      mov = mock( 'movie', :title =>"name_of_movie" )
      array = ["a", "x", "i"]
      Movie.stub( :all_ratings ).and_return( array )
      session[ :ratings ] = "no_adult"
      get :index, { :ratings =>"adult" }
      response.should redirect_to movies_path :ratings =>"adult"
    end


    it 'should render index' do
      mov = mock( 'movie', :title =>"name_of_movie" )
      Movie.stub( :all_ratings ).and_return( ["a", "x", "i"] )
      Movie.stub( :find_all_by_rating )
      get :index
      response.should render_template 'index'
    end
  end
end

