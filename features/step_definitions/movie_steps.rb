Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create! movie
  end
end

Then /I should (not )?see following movies: (.*)$/ do |negative, array|
  array.split(/, */).each do |mov|
    steps %Q{ Then I should #{negative}see "#{mov}" }
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  regexp = /#{e1}.*#{e2}/m
  unless page.body[ regexp ]
    steps %Q{ Then I should see /#{regexp}/ }
  end
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(/, */).each do |rating|
    steps %Q{ When I #{uncheck}check "ratings[#{rating}]" }
  end
end

Then /^I should see all of the movies$/ do
  databasemovies   = Movie.all.size
  moviesshowinpage = page.all( "#movies tr" ).size - 1
  if databasemovies != moviesshowinpage
    steps %Q{ Then I should see "ErrorErrorError" }
  end
end