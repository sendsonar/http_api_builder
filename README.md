# HttpApiBuilder
A simple tool for building API clients that use HTTP.

This is for **clients** as in *consumers*, not for servers. Look into things like Rails-api or Grape for those.

[![Code Climate](https://codeclimate.com/github/paradox460/http_api_builder/badges/gpa.svg)](https://codeclimate.com/github/paradox460/http_api_builder)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'http_api_builder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install http_api_builder

## Usage

```ruby
require 'http_api_builder/client/http_rb'

class ElGoog < HttpApiBuilder::BaseClient
  include HttpApiBuilder::Client::HttpRb

  base_url 'https://google.com'

  get '/', as: :search, params: {required: :q}
end
```

You can then use the API as such:

```ruby
g = ElGoog.new

g.search(q: 'ruby')
```

See the wiki for more details.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


```
The MIT License (MIT)

Copyright (c) 2016 Jeff Sandberg

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
