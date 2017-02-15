# TraceTree

Print TracePoint(normal ruby call, block call, raise call, throw call) in tree graph.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'trace_tree'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trace_tree

## Usage

Just call the method you want to trace in the block passed to `binding.trace_tree`:

```ruby
things_done = binding.trace_tree do
  somebody.do_something
end
```

### Parameters

You may pass optional parameters while invoking `binding.trace_tree`:

```ruby
binding.trace_tree(file, color: false, gem: false) do
  somebody.do_something
end
```

* `file == STDOUT` by default. You can give it a File object or anything responds to `puts`.
* `:color => true` by default. It makes method names have different color than source_location in output. When you print the output to file, you may want to set it false to discard those color ANSI escape sequences.
* `:gem => true` by default. Replace the gem paths in source_location with $GemPathN, can make the lines shorter. To see what are replaced, inspect `TraceTree::GemPaths`.
* `:html => nil` by default. Set it true to generate a html in which a tree constructed with `<ul>`, `<li>`.

### Example

Want to know what `Sinatra::Base#call` does? Wrap it with `binding.trace_tree`:

```ruby
require 'sinatra'
require 'trace_tree'

get '/' do
  'wtf'
end

class Sinatra::Base
  alias_method :o_call, :call

  def call env
    binding.trace_tree do
      o_call env
    end
  end
end
```

Execute that sinatra script as normal, then you will see in console:

```
Sinatra::Application#block in call sin.rb:12
└─Sinatra::Application#call $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:894
  └─Sinatra::Application#call! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:898
    ├─Sinatra::Request#initialize $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:16
    ├─Sinatra::Response#initialize $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:124
    │ ├─Sinatra::Response#initialize $GemPath0/gems/rack-1.6.5/lib/rack/response.rb:25
    │ │ ├─Rack::Utils::HeaderHash.new $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:489
    │ │ │ └─Rack::Utils::HeaderHash#initialize $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:493
    │ │ ├─Rack::Utils::HeaderHash#merge $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:542
    │ │ │ └─Rack::Utils::HeaderHash#merge! $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:537
    │ │ └─Rack::Utils::HeaderHash#[] $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:511
    │ ├─Rack::Utils::HeaderHash#[] $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:511
    │ └─Rack::Utils::HeaderHash#[]= $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:515
    ├─Sinatra::Request#params $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:229
    │ ├─Sinatra::Request#GET $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:187
    │ │ ├─Sinatra::Request#query_string $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:24
    │ │ ├─Sinatra::Request#query_string $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:24
    │ │ ├─Sinatra::Request#parse_query $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:368
    │ │ │ └─Rack::Utils.parse_nested_query $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:116
    │ │ │   ├─Rack::Utils::KeySpaceConstrainedParams#initialize $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:555
    │ │ │   └─Rack::Utils::KeySpaceConstrainedParams#to_params_hash $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:575
    │ │ └─Sinatra::Request#query_string $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:24
    │ └─Sinatra::Request#POST $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:201
    │   ├─Sinatra::Request#form_data? $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:174
    │   │ └─Sinatra::Request#media_type $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:42
    │   │   └─Sinatra::Request#content_type $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:27
    │   └─Sinatra::Request#parseable_data? $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:182
    │     └─Sinatra::Request#media_type $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:42
    │       └─Sinatra::Request#content_type $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:27
    ├─Sinatra::Application#indifferent_params $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1047
    │ └─Sinatra::Application#indifferent_hash $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1061
    ├─Sinatra::Application#settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:927
    │ └─Sinatra::Application.settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:922
    ├─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1885
    ├─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1885
    │ └─Sinatra::Application.development? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1404
    │   └─Sinatra::Application.environment (eval):1
    ├─Tilt::Cache#clear $GemPath0/gems/tilt-2.0.6/lib/tilt.rb:109
    ├─Sinatra::Application#force_encoding $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1810
    │ ├─Sinatra::Application#settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:927
    │ │ └─Sinatra::Application.settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:922
    │ └─Sinatra::Application.force_encoding $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1812
    │   └─Sinatra::Application.settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:922
    ├─Sinatra::Response#[]= $GemPath0/gems/rack-1.6.5/lib/rack/response.rb:56
    │ └─Rack::Utils::HeaderHash#[]= $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:515
    ├─Sinatra::Application#invoke $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1066
    │ └─Sinatra::Application#block in invoke $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1067
    │   └─Sinatra::Application#block in call! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:907
    │     └─Sinatra::Application#dispatch! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1081
    │       ├─Sinatra::Application#invoke $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1066
    │       │ ├─Sinatra::Application#block in invoke $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1067
    │       │ │ └─Sinatra::Application#block in dispatch! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1082
    │       │ │   ├─Sinatra::Application#settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:927
    │       │ │   │ └─Sinatra::Application.settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:922
    │       │ │   ├─Sinatra::Application.static? (eval):1
    │       │ │   │ ├─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1890
    │       │ │   │ └─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1890
    │       │ │   │   ├─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1889
    │       │ │   │   ├─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1889
    │       │ │   │   │ ├─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │       │ │   │   │ ├─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │       │ │   │   │ │ ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │       │ │   │   │ │ ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │       │ │   │   │ │ ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │       │ │   │   │ │ └─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │       │ │   │   │ ├─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │       │ │   │   │ └─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │       │ │   │   │   ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │       │ │   │   │   ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │       │ │   │   │   ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │       │ │   │   │   └─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │       │ │   │   ├─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1889
    │       │ │   │   └─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1889
    │       │ │   │     ├─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │       │ │   │     ├─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │       │ │   │     │ ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │       │ │   │     │ ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │       │ │   │     │ ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │       │ │   │     │ └─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │       │ │   │     ├─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │       │ │   │     └─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │       │ │   │       ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │       │ │   │       ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │       │ │   │       ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │       │ │   │       └─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │       │ │   ├─Sinatra::Application#filter! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:964
    │       │ │   │ └─Sinatra::Application#filter! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:964
    │       │ │   └─Sinatra::Application#route! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:970
    │       │ │     ├─Sinatra::Request#request_method $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:23
    │       │ │     └─Sinatra::Application#block in route! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:972
    │       │ │       └─Sinatra::Application#process_route $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1002
    │       │ │         ├─Sinatra::Request#path_info $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:22
    │       │ │         └─Sinatra::Application#block in process_route $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1013
    │       │ │           └─Sinatra::Application#block (2 levels) in route! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:973
    │       │ │             └─Sinatra::Application#route_eval $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:993
    │       │ │               ├─Sinatra::Application#block (3 levels) in route! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:975
    │       │ │               │ └─Sinatra::Application.block in compile! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1611
    │       │ │               │   ├─Sinatra::Application#block in <main> sin.rb:4
    │       │ │               │   └─Sinatra::Application#block in <main> sin.rb:4
    │       │ │               └─throw in Sinatra::Application#route_eval $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:994
    │       │ └─Sinatra::Application#body $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:238
    │       │   ├─Sinatra::Request#head? $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:122
    │       │   │ └─Sinatra::Request#request_method $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:23
    │       │   ├─Object#require /home/z/.rbenv/versions/2.4.0/lib/ruby/2.4.0/rubygems/core_ext/kernel_require.rb:39
    │       │   │ ├─Monitor#mon_enter /home/z/.rbenv/versions/2.4.0/lib/ruby/2.4.0/monitor.rb:185
    │       │   │ ├─Gem.find_unresolved_default_spec /home/z/.rbenv/versions/2.4.0/lib/ruby/2.4.0/rubygems.rb:1240
    │       │   │ │ ├─Gem.suffixes /home/z/.rbenv/versions/2.4.0/lib/ruby/2.4.0/rubygems.rb:1003
    │       │   │ │ ├─Gem.block in find_unresolved_default_spec /home/z/.rbenv/versions/2.4.0/lib/ruby/2.4.0/rubygems.rb:1241
    │       │   │ │ ├─Gem.block in find_unresolved_default_spec /home/z/.rbenv/versions/2.4.0/lib/ruby/2.4.0/rubygems.rb:1241
    │       │   │ │ └─Gem.block in find_unresolved_default_spec /home/z/.rbenv/versions/2.4.0/lib/ruby/2.4.0/rubygems.rb:1241
    │       │   │ ├─Gem::Specification.unresolved_deps /home/z/.rbenv/versions/2.4.0/lib/ruby/2.4.0/rubygems/specification.rb:1296
    │       │   │ └─Monitor#mon_exit /home/z/.rbenv/versions/2.4.0/lib/ruby/2.4.0/monitor.rb:197
    │       │   │   └─Monitor#mon_check_owner /home/z/.rbenv/versions/2.4.0/lib/ruby/2.4.0/monitor.rb:247
    │       │   ├─Sinatra::Application#headers $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:298
    │       │   ├─Rack::Utils::HeaderHash#delete $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:522
    │       │   │ ├─Rack::Utils::HeaderHash#block in delete $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:525
    │       │   │ └─Rack::Utils::HeaderHash#block in delete $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:525
    │       │   └─Sinatra::Response#body= $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:129
    │       └─Sinatra::Application#filter! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:964
    │         └─Sinatra::Application#filter! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:964
    ├─Sinatra::Application#invoke $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1066
    │ └─Sinatra::Application#block in invoke $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1067
    │   └─Sinatra::Application#block in call! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:908
    │     └─Sinatra::Application#error_block! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1128
    │       └─Sinatra::Application#settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:927
    │         └─Sinatra::Application.settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:922
    ├─Sinatra::Response#[] $GemPath0/gems/rack-1.6.5/lib/rack/response.rb:52
    │ └─Rack::Utils::HeaderHash#[] $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:511
    ├─Sinatra::Application#body $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:238
    ├─Sinatra::Application#body $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:238
    ├─Sinatra::Application#content_type $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:320
    │ ├─Sinatra::Application#mime_type $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:314
    │ │ └─Sinatra::Base.mime_type $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1312
    │ │   └─Rack::Mime.mime_type $GemPath0/gems/rack-1.6.5/lib/rack/mime.rb:16
    │ ├─Sinatra::Application#settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:927
    │ │ └─Sinatra::Application.settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:922
    │ ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ ├─Sinatra::Application#block in content_type $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:326
    │ ├─Sinatra::Application#block in content_type $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:326
    │ ├─Sinatra::Application#block in content_type $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:326
    │ ├─Sinatra::Application#block in content_type $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:326
    │ ├─Sinatra::Application#settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:927
    │ │ └─Sinatra::Application.settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:922
    │ ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ ├─Sinatra::Application#block in content_type $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:332
    │ └─Sinatra::Response#[]= $GemPath0/gems/rack-1.6.5/lib/rack/response.rb:56
    │   └─Rack::Utils::HeaderHash#[]= $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:515
    └─Sinatra::Response#finish $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:138
      ├─Sinatra::Response#drop_content_info? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:166
      │ └─Sinatra::Response#drop_body? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:170
      ├─Sinatra::Response#drop_body? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:170
      ├─Sinatra::Response#calculate_content_length? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:162
      │ ├─Rack::Utils::HeaderHash#[] $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:511
      │ └─Rack::Utils::HeaderHash#[] $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:511
      ├─Sinatra::Response#block in finish $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:154
      │ └─Rack::Utils.bytesize $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:379
      └─Rack::Utils::HeaderHash#[]= $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:515
```

