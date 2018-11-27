# RequestSignature

A gem that uniquely signs API requests so that a receiver can be sure they came from you. It can also verify signed requests, assuming they were signed in the same way.

It has no runtime dependencies other than Ruby stdlib and minimal dev dependencies.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'request_signature'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install request_signature

## Usage

There are two main classes: `Request` and `Verification`.

`Request` allows you prepare a signed request with your secret key and the params you want to send.

`Verification` allows you to verify that an incoming request is valid (ie. the signature matches the combination of parameters and signature time) and that the request was sent during the validity period.

### Creating a Signed Request

```ruby
params = {
  name: 'John',
  age: 35
}
request = RequestSignature::Request.new(params: params, secret: 'my-secret-key')
signature = request.signature # eg. "3e01567d3e7cbecaa0112a419dc1d24cb359d20d2a5913adef347a9a666a4fbd"
signed_at = request.time # in epoch seconds
headers = request.headers # see below
```

The headers are some useful defaults you can merge into the headers hash of your http client:
```ruby
{
  'X-Request-Signature': 3e01567d3e7cbecaa0112a419dc1d24cb359d20d2a5913adef347a9a666a4fbd,
  'X-Signature-Time': 1543346191
}
```

### Verifying a Request

The following example assumes your API is built on Rails:
```ruby
class ApiController < ApplicationController
  before_action :verify_request_signatures

  rescue_from RequestSignature::InvalidSignatureError, with: :invalid_signature_error
  rescue_from RequestSignature::PeriodExpiredError, with: :period_expired_error

  def verify_request_signatures
    secret_key = ApiClient.get(CLIENT_ID).secret # Your logic here.

    signed_at = request.headers['X-Signature-Time']
    signature = request.headers['X-Request-Signature']
    verification = RequestSignature::Verification.new(
      signature: signature,
      secret: secret_key,
      time: time,
      params: params
    )

    verification.verify! # Raises exceptions on failure.
  end

  def invalid_signature_error
    # ...
  end

  def period_expired_error
    # ...
  end
end
```

## What It Does

RequestSignature uses [OpenSSL::HMAC](https://ruby-doc.org/stdlib-2.5.1/libdoc/openssl/rdoc/OpenSSL/HMAC.html) to convert a string and your secret key into a verifiable signature for a particular request.

It constructs the input string by generating a JSON formatted string and combining it with the time the request is signed. The format of the string is:

```
"#{time}:#{JSON.generate(your_params_hash)}"
```

It's up to you to create an API key / secret key combination that allows you to identify someone calling your API and retrieve their secret key from your key storage.

**Always use SSL.**

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

Write codes, write tests, and create a PR when you're satisfied.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/multiplegeorges/request_signature. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the RequestSignature project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/multiplegeorges/request_signature/blob/master/CODE_OF_CONDUCT.md).
