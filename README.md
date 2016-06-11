# Formerer

Formerer provides end points to send your forms to from your static sites.

Heavily WIP!

To start Formerer:

  1. Install dependencies with `mix deps.get`
  2. Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  3. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

#### Testing

Formerer uses [hound](https://github.com/HashNuke/hound) for feature tests.

Please do make sure you have a webdriver server running before running the test suite.

The hound wiki has a great section that might be useful titled [Starting a webdriver server](https://github.com/HashNuke/hound/wiki/Starting-a-webdriver-server)

### TODO

- [ ] More tests!
- [ ] Document usage
- [ ] Elixirify code
- [ ] Notifications & integrations (email, slack, chrome, drive etc)
