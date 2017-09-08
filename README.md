# Location based hotels search and fake check-ins app

It's a simple location based hotel search and creates fake check-ins.

It used google search API to get the hotels based on the location.

It has a cron job which exports a CSV file and imports checked-in data for previous day.

# Installation

Pull the repository

`> bundle install`<br>
`> rake db:create`<br>
`> rake db:migrate`<br>
`> rake db:seed`

Please put your own GOOGLE_LOCATION_SEARCH_API_URL and GOOGLE_LOCATION_SEARCH_API_KEY in `.env` file of root folder. 

Start the server and hit localhost:3000

# Setup cron

`> whenever` <br>
`> whenever --update-crontab`

# JSON APIs

1. `<app_domain>/checkins` will list all hotel checkins
2. `<app_domain>/checkins?arrival_date=<Date>` will list all hotel checkins made on the arrival date
3. `<app_domain>/checkins?city_name=<city_name>` will list all hotel checkins made in the city
4. `<app_domain>/<user_id>/checkins` will list all user's hotel checkins
