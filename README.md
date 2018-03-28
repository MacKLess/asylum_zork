# Asylum Zork

#### _Epicodus Team Project in Ruby_

#### By Kelsey Langlois, L. Devin MacKrell, Tyler Miller, and Dan Nollette

## Description

_A Zork homage set in a haunted asylum. Built in Ruby Script using Active Record and SQL._

## Setup/Installation Requirements

_You can play this game online at: [stark-eyrie-10328.herokuapp.com](https://stark-eyrie-10328.herokuapp.com/). To install the game on your own machine use the following steps:_

* Clone this repository at [https://github.com/MacKLess/asylum_zork.git](https://github.com/MacKLess/asylum_zork.git)
* Ensure you have Postgres installed and running ([instructions here](https://www.learnhowtoprogram.com/ruby/ruby-database-basics/installing-postgres-7fb0cff7-a0f5-4b61-a0db-8a928b9f67ef))
* To set up the development database, run the following commands in the project's root directory:
  * ```bundle install```
  * ```rake db:create```
  * ```rake db:environment:set```
  * ```rake db:migrate```
* After the development database is set up, run ```ruby app.rb``` in the project's root directory
* Open ```localhost:4567``` in your web browser

## Specifications

* _User will interact within a asylum based maze using text only input._
* _User will be able to navigate through open doors using cardinal directions or N, E, S, W._
* _User will be able to read notes found in specific rooms using the "read note" command._
* _User will be able to collect items which are then stored in inventory using the "take [item]" command._
* _User will be able to view inventory items by using the "inventory" command._
* _User will be able to use items in specific rooms by using the "use [item] command._
* _User will be able to view the room by using the "look" command._
* _User will be able to review commands by using the "help" command._
* _User will be provided with a score/assessment upon completion of the game._

## Known Bugs

* Multiple users playing the game on Heroku creates errors, as all instances operate on the same database. Since the Heroku app only supports one player at a time, it's recommended that users download and run the app using a local database.

## Support and contact details

_Please contact [kels.langlois@gmail.com](mailto:kels.langlois@gmail.com), [ldmackrell@gmail.com](mailto:ldmackrell@gmail.com), [tylermiller94@gmail.com](mailto:tylermiller94@gmail.com), or [nollette.dan@gmail.com](mailto:nollette.dan@gmail.com) with questions, comments, or issues, or to contribute to the code._

## Technologies Used

* Ruby
* Sinatra
* ActiveRecord
* Postgres

### License

Copyright (c) 2018 **Kelsey Langlois, L. Devin MacKrell, Tyler Miller, Dan Nollette**

*This software is licensed under the MIT license.*
