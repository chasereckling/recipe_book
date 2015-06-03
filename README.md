Recipe Book version 1.0 (05/13/15)
-------------------

What is it?
-----------

Recipe Book is a program that allows users to add and keep track of recipes. Additionally the user can add ingredients and ratings to their recipes.

Setup:
------

Recipe Book uses ruby version 2.2.0.

1. After you download Recipe Book navigate to the 'recipe_book' file folder in your terminal then run the following command to install the Gemfile:

   $ bundle install
   
2. Run postgres in the terminal:

   $ postgres

3. To create the database, type in the terminal:
   
   $ rake db:create
   $ rake db:migrate

4. Run ruby app.rb in the terminal:

   $ ruby app.rb

5. In your browser navigate to the url: localhost:4567.

Copyright and Licensing:
------------------------

For copyright and licensing Recipe Book uses the GNU GENERAL PUBLIC LICENSE, version 2.

Author:
-------

Chase Reckling chase.reckling@gmail.com
