# Writing Performance Tests

In the suite directory, create a subclass of `Deathstare::Suite` and use the `test` method to create
test cases. In the body of each test you have your own `Device`, logged in and ready to use,
and helper methods from `SuiteHelper`.

    class MyCreationSuite < Deathstare::Suite
      test "get a creation" do |device|
        # Each test iteration gets a new logged-in device.
        # You can perform requests using the device to get a promise for a result.
        # Session information is sent automatically with each request.
        device.get("/api/creations/1").then do |result|
          # Call then on the promise to provide a callback that processes the result.
          # You can make additional API calls on the device inside a callback.
          puts "Creation is named #{result[:response][:name]}"
          device.patch("/api/creations/1", {name:"frank"})
        end
      end

      test "post a creation" do |device|
        device.post("/api/creations", {name:"ralph"}).then do |result|
          puts "Got message: #{result[:response][:messages].join}"
          # You must return either a result or another promise,
          # in this case we'll just return the original result.
          result
        end
      end
    end

**Always** return either a valid result OR a dependent request promise in promise callbacks.
This is necessary to properly construct the request chain. Keep in mind that in Ruby blocks
will automatically return the last evaluated value.

**Never** use instance vars ("@-vars") in test code. If you feel that you can't implement your test
without them, talk to Zack about it and we'll find a solution.

See `suite/arthaus_suite.rb` for more examples.

## Repeating Request Helpers

In order for tests to be properly concurrent, it's important that you chain all requests and return
the result of this chain at the bottom. This allows the suite to append additional behaviors to the
end of the chain. To this end, `SuiteHelper` provides helpers that allow you to chain a series of
requests in one call:

    # you can repeat a given number of times...
    test "create five identical things" do |device|
      request_times(5) { device.post '/api/creations', name:'thingy' }.then do
        # In this block, all request have successfully completed.
      end
    end

    # ...or loop over an array of values
    test "create five different things" do |device|
      request_each(1..5.to_a) {|n| device.post '/api/creations', name:"thing #{n}" }.then do
        # In this block, all request have successfully completed.
      end
    end

## Advanced Promise Chaining

Because returned promises chain, it's possible to handle dependent requests further
down the promise chain. For example, these two are equivalent:

    device.get("/api/creation/#{creation_id}").then do |result|
      device.patch("/api/creation/#{creation_id}", result.merge(name:'new name')).then do |result|
        # Do something with the PATCH response.
        device.delete("/api/creations/#{result[:response][:creation_id]")
      end
    end

    device.get("/api/creation/#{creation_id}").then do |result|
      device.patch("/api/creation/#{creation_id}", result.merge(name:'new name'))
    end.then do |result|
      # Do something with the PATCH response.
      device.delete("/api/creations/#{result[:response][:creation_id]")
    end

Use this technique to keep chain dependent requests without nesting too deeply in your test code.
Remember that every callback **must** return either a valid result OR a dependent promise!

