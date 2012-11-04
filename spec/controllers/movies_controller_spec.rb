require 'spec_helper'

describe MoviesController do
  describe 'find movie with same director' do
    it 'a RESTful route for "find similar movies"' do
      get :find_similar_movies
    end
    it 'should call the model method that gets the list of movies with same director'
    it 'should i do not know yet'
    it 'should i do not know even yet'
  end
end

