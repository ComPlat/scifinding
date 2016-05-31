
# Scifinding

A plugin for the [Chemotion ELN][chemotion_eln].

implement some of the [Scifinder (R)][scifinder] search functionalities into the ELN through their API.

You will need an institution login/password for this service (see Local setup).  
Also, each user need to fetch their access token once (see How to).


## Install

To the chemotion_ELN Gemfile, add:
```ruby
gem "scifinding", :git => "git://github.com/complat/scifinding.git" , :group => [:plugins,:test,:development,:production]
```
(of course, run: ```bundle install```)

From your chemotion_ELN app root, run:
```ruby
rake db:migrate
```

## Local setup

Configure your local env variables through your .env file.
See the  scifinding_env.yml.example for the required parameters.
(alternatively have a scifinding_env.yml file in your ELN config folder and a scifinding.rb initializer (see scifinding.rb.initializer_example)).  


## How to

First thing to do, once you are logged in, is to go your 'Account settings'
to request an access token with your Scifinder (R) user name and pw.
If you see a valid expiry date, you are ready to use the new ELN functionalities.
An expired token should be renewed automatically while querying.


## Contributions

Yes please! See the [contributing guidelines][contributing] for details.


This project rocks and uses [MIT-LICENSE][license].

[chemotion_eln]: https://github.com/ComPlat/chemotion_ELN
[license]: MIT-LICENSE
[scifinder]:http://www.cas.org/products/scifinder
