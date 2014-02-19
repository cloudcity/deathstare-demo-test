# DEATHSTARE-DEMO-TEST

This is a simple suite of performance tests, implemented using the Deathstare Rails Engine.

It is one half of a set of two applications that demonstrate how you would performance test your own
JSON API application. The other half is DEATHSTARE-DEMO-AUT (where AUT is the generally accepted acronym for
Application Under Test), a simple JSON API application, that is the testing target of DEATHSTARE-DEMO-TEST.

Using [Deathstare](https//github.com/cloudcity/deathstare) to power the dashboard
and job runners, this repo contains a Rails app to mount Deathstare, a suite of
performance tests, and some client API glue.

## Quickstart

You will need two applications on your development machine to run this demonstration, so first get the
deathstare-demo-aut then deathstare-demo-test.

Clone deathstare-demo-aut onto your development machine.

Get a Librato free trial account by visiting www.librato.com.

From the Librato site, create an API token.

Set these ENV variables:

* `LIBRATO_EMAIL` to your Librato account email
* `LIBRATO_API_TOKEN` to your Librato API token

Clone deathstare-demo-test onto your development machine

Start deathstare-demo-aut using rails server

Start deathstare-demo-test as follows:

  Start your local Postgres and Redis first
  Start the workers and Rails server, then open the dashboard:

    foreman start -p 4000 &     # (Heroku dev sign-in wants port 4000)
    open http://localhost:4000/ # view the test dashboard

## More detail

We've included a simple example on github to let you play with Deathstare locally and see how it works.

There are three 'components' to a Deathstare tested application.

1 - Your application that needs to be tested. In test terms, this is the Application Under Test (AUT).
Our example is available at: github.com/cloudcity/deathstare-demo-aut.

2 - Deathstare, a Rails engine

3 - The application you write to perform the testing, and include the Deathstare engine. In test terms,
this is the Testing Application. Our example is available at: github.com/cloudcity/deathstare-demo-test.

In our simple example:

The Application under test is called deathstare-demo-aut. It is a minimalistic application in that it simulates an API
that allows the caller to create users, login a user, create a client_device, and manage a set of widgets by creating a
widget, listing all existing widgets, and deleting a widget.

Because we are only attempting to demonstrate how to write a testing application, the user, login, and client_device
endpoints do not really perform those functions but return a good status as though they have done some real work. The
widget endpoints, however, do perform real work.

users#create
login#create
client_devices#create
widget#create
widget#index
widget#delete

The Testing Application is called deathstare-demo-test.

If you decide to make your own test application, the following files would have to be configured for that application.

#####models/widget_device.rb

This file sub-classes Deathstare::UpstreamSession. It is how you tell Deathstare
how to create the device locally within Deathstare and how you create, register,
and login that device in your actual application.

Our example assumes that you must first create a device, then register the device,
then login the device before the session is ready to be used. You might have a
different sequence and here is where you would set up those steps.

#####config/initializers/deathstare.rb

Use this file to specify the configuration information that Deathstare needs.
Note that config.upstream_session_type should be set to the class name you
specified in  models/widget_device.rb.

To use Deathstare you must have a Librato account. Fortunately, there is a
thirty-day free trial account. Go to librato.com to sign up.

Once you've signed up, generate an api access key.

Then set ENV variables LIBRATO_EMAIL and LIBRATO_API_TOKEN to your values.

#####/config/application.rb

Specify the name of the module representing your test application.

#####/config/environment.rb

Initialize your application here.

#####/config/routes.rb

Mount the Deathstare engine here.

#####/lib/widget_fake/widget.rb

In this file, we've put the methods we use to fake a Widget.

#####/lib/widget_fake.rb

Here's where we required /lib/widget_fake.rb

#####/suite/widgets_suite_create_and_list.rb

The suite directory is where your write the code of your test suites and tests.

A suite is in a file, and a suite file can contain the one or more tests that make
up that suite. How you set up your suites and tests is up to your needs.
One approach would be to have a suite for each set of endpoints in your
application. For example, a widgets suite that tests creating, listing, updating,
and deleting a widget. If your app also had a set of images endpoints to create,
list, update, and delete images, a second suite might be created for that
load testing.

In our example, we have three tests in this file.

 The three tests illustrate different testing ideas.

test '1 - create widgets' is the simplest test - it merely calls the widget#create
endpoint for each device you've specified in your test execution. So if you've
specified 20 devices from the dashboard, this test will be executed once for each
of the twenty devices.

test '2 - widgets list' shows how you would perform an action a multiple of times.
This test will be called once for each device, and repeat its action 10 times.

test '3 - create a widget, get list of all widgets, then delete the widget' shows
a more complex scenario that includes cascading different endpoint calls that are
interrelated.

This example creates 10 widgets (for each device) and stores the widget ids in an
array. Once that's complete, it requests a list of all widgets in the system, and
once that's done, it calls the delete endpoint for each of the widgets in the array.

This final example gives you a taste of the power that Deathstare gives you in
performing load tests on your application. If there are scenarios that you believe
represent a pattern that a group of users might perform against your application,
you can program a test that mimics that predicted behavior and see how your
application handles it.

## Development

NOTE: You'll need to have Postgres and Redis running before you do this.

First start the workers and Rails server, then open the dashboard:

    foreman start -p 4000 &     # (Heroku dev sign-in wants port 4000)
    open http://localhost:4000/ # view the test dashboard

You can kick off test runs using the dashboard. The tests run in async workers.
For extra interesting output we (currently) recommend you watch the worker logs while the
test is running.

To view the documentation in your browser, with the dashboard running:

    rake yard
    open http://localhost:4000/doc

### Deploying to Heroku

After you've played with the demo, you will have seen just some of the power of Deathstare.

When you run a Deathstare test app locally, you can specify multiple concurrent devices.

When you deploy that same Deathstare test app on Heroku, you can specify up to 100 concurrent instances running as well.
Each of those instances will present load for the number of concurrent devices you specify on the dashboard.

To set that up, you will have to deploy your test app to Heroku, set up OAuth for the application, and set up
three Heroku environment variables:

* `HEROKU_APP_ID`
* `HEROKU_OAUTH_ID`
* `HEROKU_OAUTH_SECRET`

When you run your test app on Heroku, you will have the option to set a number of concurrent instances (up to 100) for
your test run. That comes with the corresponding cost of running those Heroku instances during the test run, but it is
relatively inexpensive for the amount of load testing you will be able to generate. Deathstare spins down the instances
when the test run completes.

### Starting a suite from the command line

You still need the workers running to do this. This process is very similar to how the
dashboard operates but works from the command line. Each suite is a single rake task.

You can see a list of available suites:

    rake -T suite:

When using rake, suites can be configured using environment variables:

* `BASE_URL` specifies the DS API endpoint being tested (defaults to `http://localhost:3000`)
* `DEVICES` specifies how many devices/iterations to run of each test (defaults to 10)
* `RUN_TIME` specifies the *minimum* run time of the test (defaults to 0)

### Running a suite synchronously

If you'd like to run the tests synchronously on your local machine, you can
open a ruby console with the suite loaded and run tests by hand. This
does **not** require that workers are running.

    rails console
    > session = Deathstare::TestSession.create base_url:'http://localhost:3000',  devices:10
    > # you'll need this whenever you reset your session cache or want more devices:
    > session.initialize_devices
    > # run a whole suite...
    > MySuite.new.perform(test_session_id:session.id)
    > # or run a single test
    > MySuite.new.perform(test_session_id:session.id, name:'it can hit the home page')

### Updating Deathstare

To update the Deathstare dependency in development, make sure your Deathstare changes
are *committed AND pushed*, then:

    bundle update --source deathstare
    git add Gemfile.lock
    git commit -m 'Update deathstare dependency.'

This will update the Gemfile.lock with the latest revision and force an update on deploy.

## A note about Session and Device caching

Deathstare pre-generates and caches devices and sessions in `ClientDevice` records. In cases
where changes are made to upstream session creation and/or data is deleted/reset, it may
be necessary to clear the session/device cache. You should try this first if you're having
mysterious problems with login during your test run. To clear the cache from the command line:

    rake sessions:reset

By default this operates on `http://localhost:3000`. To use another end point, you must specify it
explicitly in the environment as `BASE_URL`.