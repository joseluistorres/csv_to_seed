= csv_to_seed

This gem is a basic tool for those who get annoyed by parsing CSVs file to import them to their DBs,
instead this script just read the CSV file and write an array based on the file to seed.rb for Rails Apps.

```
  $ csv_to_seed 'path_to_CSV_file' 'name_of_the_array'
```

@TODO
-  Add testing to the class
-  Unhardcode the structure to insert
-  Update the README

== Contributing to csv_to_seed

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2014 JoseLuis Torres. See LICENSE.txt for
further details.
