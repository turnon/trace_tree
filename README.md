# TraceTree

Print TracePoint(`:b_call`, `:b_return`, `:c_call`, `:c_return`, `:call`, `:return`, `:class`, `:end`, `:thread_begin`, `:thread_end`) in tree view, to console or html.

*Notice: it does not trace `:raise`, which can be represented by Kernel#raise(`:c_call`)*

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

You may pass optional parameters while invoking `binding.trace_tree`, for example:

```ruby
binding.trace_tree(file, color: false, gem: false) do
  somebody.do_something
end
```

* `file == STDOUT` by default. You can give it a File object or anything responds to `puts`.
* `:color => true` by default. It makes method names have different color than source_location in output. When you print the output to file, you may want to set it false to discard those color ANSI escape sequences.
* `:gem => true` by default. Replace the gem paths in source_location with $GemPathN, can make the lines shorter. To see what are replaced, inspect `TraceTree::GemPaths`.
* `:html => nil` by default. Set it true to generate a html in which a tree constructed with `<ul>`, `<li>`. (No need to set `color`).
* `:tmp => nil` by default. Set it true or a string or an array of string to specify a tmp file under the default tmp dir of your system. (No need to provide `file` argument. It makes parent directories as needed)
* `:timer => nil` by default. Set it true if you want to know how much time spent in tracing and drawing tree. Notice the `file` should be appendable, otherwise the time will overwrite the tree.

### Example

Want to know what `Sinatra::Base#call` does? Wrap it with `binding.trace_tree`:

```ruby
require 'sinatra'
require 'trace_tree'

get '/' do
  'welcome'
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
  ├─Kernel#dup $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:895
  │ └─Kernel#initialize_dup $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:895
  │   └─Kernel#initialize_copy $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:895
  └─Sinatra::Application#call! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:898
    ├─Class#new $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:900
    │ └─Sinatra::Request#initialize $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:16
    ├─Class#new $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:901
    │ └─Sinatra::Response#initialize $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:124
    │   ├─Sinatra::Response#initialize $GemPath0/gems/rack-1.6.5/lib/rack/response.rb:25
    │   │ ├─Integer#to_i $GemPath0/gems/rack-1.6.5/lib/rack/response.rb:26
    │   │ ├─Rack::Utils::HeaderHash.new $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:489
    │   │ │ ├─Module#=== $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:490
    │   │ │ └─Class#new $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:490
    │   │ │   └─Rack::Utils::HeaderHash#initialize $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:493
    │   │ │     ├─Hash#initialize $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:494
    │   │ │     └─Hash#each $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:496
    │   │ ├─Rack::Utils::HeaderHash#merge $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:542
    │   │ │ ├─Kernel#dup $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:543
    │   │ │ │ └─Kernel#initialize_dup $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:543
    │   │ │ │   └─Hash#initialize_copy $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:543
    │   │ │ └─Rack::Utils::HeaderHash#merge! $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:537
    │   │ │   └─Hash#each $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:538
    │   │ ├─Rack::Utils::HeaderHash#[] $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:511
    │   │ │ ├─Hash#[] $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:512
    │   │ │ ├─String#downcase $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:512
    │   │ │ └─Hash#[] $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:512
    │   │ ├─String#== $GemPath0/gems/rack-1.6.5/lib/rack/response.rb:29
    │   │ ├─Kernel#lambda $GemPath0/gems/rack-1.6.5/lib/rack/response.rb:30
    │   │ ├─Kernel#respond_to? $GemPath0/gems/rack-1.6.5/lib/rack/response.rb:36
    │   │ ├─Kernel#respond_to? $GemPath0/gems/rack-1.6.5/lib/rack/response.rb:38
    │   │ ├─Array#each $GemPath0/gems/rack-1.6.5/lib/rack/response.rb:39
    │   │ └─Kernel#block_given? $GemPath0/gems/rack-1.6.5/lib/rack/response.rb:46
    │   ├─Rack::Utils::HeaderHash#[] $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:511
    │   │ ├─Hash#[] $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:512
    │   │ ├─String#downcase $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:512
    │   │ └─Hash#[] $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:512
    │   └─Rack::Utils::HeaderHash#[]= $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:515
    │     ├─String#downcase $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:516
    │     └─Hash#[]= $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:519
    ├─Sinatra::Request#params $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:229
    │ ├─Sinatra::Request#GET $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:187
    │ │ ├─Sinatra::Request#query_string $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:24
    │ │ │ └─String#to_s $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:24
    │ │ ├─Sinatra::Request#query_string $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:24
    │ │ │ └─String#to_s $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:24
    │ │ ├─Sinatra::Request#parse_query $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:368
    │ │ │ ├─Module#=== $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:370
    │ │ │ └─Rack::Utils.parse_nested_query $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:116
    │ │ │   ├─Class#new $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:117
    │ │ │   │ └─Rack::Utils::KeySpaceConstrainedParams#initialize $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:555
    │ │ │   ├─String#split $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:119
    │ │ │   ├─Array#each $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:119
    │ │ │   └─Rack::Utils::KeySpaceConstrainedParams#to_params_hash $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:575
    │ │ │     ├─Hash#keys $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:577
    │ │ │     └─Array#each $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:577
    │ │ └─Sinatra::Request#query_string $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:24
    │ │   └─String#to_s $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:24
    │ ├─Sinatra::Request#POST $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:201
    │ │ ├─Kernel#nil? $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:202
    │ │ ├─BasicObject#equal? $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:204
    │ │ ├─Sinatra::Request#form_data? $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:174
    │ │ │ ├─Sinatra::Request#media_type $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:42
    │ │ │ │ └─Sinatra::Request#content_type $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:27
    │ │ │ │   └─NilClass#nil? $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:29
    │ │ │ └─Array#include? $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:177
    │ │ │   ├─String#== $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:177
    │ │ │   └─String#== $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:177
    │ │ └─Sinatra::Request#parseable_data? $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:182
    │ │   ├─Sinatra::Request#media_type $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:42
    │ │   │ └─Sinatra::Request#content_type $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:27
    │ │   │   └─NilClass#nil? $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:29
    │ │   └─Array#include? $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:183
    │ │     ├─String#== $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:183
    │ │     └─String#== $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:183
    │ └─Hash#merge $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:230
    │   └─Kernel#initialize_dup $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:230
    │     └─Hash#initialize_copy $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:230
    ├─Sinatra::Application#indifferent_params $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1047
    │ ├─Module#=== $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1049
    │ ├─Sinatra::Application#indifferent_hash $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1061
    │ │ └─Class#new $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1062
    │ │   └─Hash#initialize $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1062
    │ └─Hash#each $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1051
    ├─Sinatra::Application#settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:927
    │ ├─Kernel#class $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:928
    │ └─Sinatra::Application.settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:922
    ├─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1885
    │ └─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1885
    │   └─Sinatra::Application.development? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1404
    │     └─Sinatra::Application.environment (eval):1
    ├─Tilt::Cache#clear $GemPath0/gems/tilt-2.0.6/lib/tilt.rb:109
    ├─Sinatra::Application#force_encoding $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1810
    │ ├─Sinatra::Application#settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:927
    │ │ ├─Kernel#class $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:928
    │ │ └─Sinatra::Application.settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:922
    │ ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ │ └─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ └─Sinatra::Application.force_encoding $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1812
    │   ├─Sinatra::Application.settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:922
    │   ├─Hash#== $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1813
    │   ├─Kernel#is_a? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1813
    │   ├─Kernel#respond_to? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1814
    │   ├─Kernel#respond_to? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1816
    │   └─Hash#each_value $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1817
    ├─Sinatra::Response#[]= $GemPath0/gems/rack-1.6.5/lib/rack/response.rb:56
    │ └─Rack::Utils::HeaderHash#[]= $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:515
    │   ├─String#downcase $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:516
    │   └─Hash#[]= $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:519
    ├─Sinatra::Application#invoke $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1066
    │ ├─Kernel#catch $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1067
    │ │ └─Sinatra::Application#block in invoke $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1067
    │ │   └─Sinatra::Application#block in call! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:907
    │ │     └─Sinatra::Application#dispatch! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1081
    │ │       ├─Sinatra::Application#invoke $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1066
    │ │       │ ├─Kernel#catch $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1067
    │ │       │ │ └─Sinatra::Application#block in invoke $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1067
    │ │       │ │   └─Sinatra::Application#block in dispatch! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1082
    │ │       │ │     ├─Sinatra::Application#settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:927
    │ │       │ │     │ ├─Kernel#class $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:928
    │ │       │ │     │ └─Sinatra::Application.settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:922
    │ │       │ │     ├─Sinatra::Application.static? (eval):1
    │ │       │ │     │ └─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1890
    │ │       │ │     │   └─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1890
    │ │       │ │     │     ├─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1889
    │ │       │ │     │     │ └─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1889
    │ │       │ │     │     │   ├─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │ │       │ │     │     │   │ └─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │ │       │ │     │     │   │   ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ │       │ │     │     │   │   │ └─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ │       │ │     │     │   │   ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ │       │ │     │     │   │   │ └─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ │       │ │     │     │   │   ├─#<Class:File>#dirname $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │ │       │ │     │     │   │   └─#<Class:File>#expand_path $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │ │       │ │     │     │   ├─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │ │       │ │     │     │   │ └─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │ │       │ │     │     │   │   ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ │       │ │     │     │   │   │ └─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ │       │ │     │     │   │   ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ │       │ │     │     │   │   │ └─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ │       │ │     │     │   │   ├─#<Class:File>#dirname $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │ │       │ │     │     │   │   └─#<Class:File>#expand_path $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │ │       │ │     │     │   └─#<Class:File>#join $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1889
    │ │       │ │     │     ├─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1889
    │ │       │ │     │     │ └─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1889
    │ │       │ │     │     │   ├─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │ │       │ │     │     │   │ └─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │ │       │ │     │     │   │   ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ │       │ │     │     │   │   │ └─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ │       │ │     │     │   │   ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ │       │ │     │     │   │   │ └─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ │       │ │     │     │   │   ├─#<Class:File>#dirname $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │ │       │ │     │     │   │   └─#<Class:File>#expand_path $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │ │       │ │     │     │   ├─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │ │       │ │     │     │   │ └─Sinatra::Application.block in <class:Base> $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │ │       │ │     │     │   │   ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ │       │ │     │     │   │   │ └─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ │       │ │     │     │   │   ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ │       │ │     │     │   │   │ └─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ │       │ │     │     │   │   ├─#<Class:File>#dirname $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │ │       │ │     │     │   │   └─#<Class:File>#expand_path $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1883
    │ │       │ │     │     │   └─#<Class:File>#join $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1889
    │ │       │ │     │     └─#<Class:File>#exist? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1890
    │ │       │ │     ├─Sinatra::Application#settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:927
    │ │       │ │     │ ├─Kernel#class $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:928
    │ │       │ │     │ └─Sinatra::Application.settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:922
    │ │       │ │     ├─Sinatra::Application#filter! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:964
    │ │       │ │     │ ├─Class#superclass $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:965
    │ │       │ │     │ ├─Kernel#respond_to? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:965
    │ │       │ │     │ ├─Class#superclass $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:965
    │ │       │ │     │ ├─Sinatra::Application#filter! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:964
    │ │       │ │     │ │ ├─Class#superclass $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:965
    │ │       │ │     │ │ ├─Kernel#respond_to? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:965
    │ │       │ │     │ │ └─Array#each $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:966
    │ │       │ │     │ └─Array#each $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:966
    │ │       │ │     ├─Sinatra::Application#settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:927
    │ │       │ │     │ ├─Kernel#class $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:928
    │ │       │ │     │ └─Sinatra::Application.settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:922
    │ │       │ │     └─Sinatra::Application#route! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:970
    │ │       │ │       ├─Sinatra::Request#request_method $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:23
    │ │       │ │       └─Array#each $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:972
    │ │       │ │         └─Sinatra::Application#block in route! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:972
    │ │       │ │           └─Sinatra::Application#process_route $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1002
    │ │       │ │             ├─Sinatra::Request#path_info $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:22
    │ │       │ │             │ └─String#to_s $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:22
    │ │       │ │             ├─Regexp#match $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1005
    │ │       │ │             ├─MatchData#captures $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1006
    │ │       │ │             ├─Array#map! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1006
    │ │       │ │             ├─Array#any? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1008
    │ │       │ │             └─Kernel#catch $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1013
    │ │       │ │               └─Sinatra::Application#block in process_route $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1013
    │ │       │ │                 ├─Array#each $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1014
    │ │       │ │                 └─Sinatra::Application#block (2 levels) in route! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:973
    │ │       │ │                   ├─Kernel#instance_variable_get $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:974
    │ │       │ │                   └─Sinatra::Application#route_eval $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:993
    │ │       │ │                     ├─Sinatra::Application#block (3 levels) in route! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:975
    │ │       │ │                     │ └─Sinatra::Application.block in compile! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1611
    │ │       │ │                     │   ├─UnboundMethod#bind $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1611
    │ │       │ │                     │   └─Method#call $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1611
    │ │       │ │                     │     └─Sinatra::Application#block in <main> sin.rb:4
    │ │       │ │                     │       └─Sinatra::Application#block in <main> sin.rb:4
    │ │       │ │                     └─Kernel#throw $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:994
    │ │       │ ├─Module#=== $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1068
    │ │       │ ├─Module#=== $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1068
    │ │       │ ├─Module#=== $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1069
    │ │       │ ├─Array#first $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1069
    │ │       │ ├─Module#=== $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1069
    │ │       │ ├─Kernel#respond_to? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1074
    │ │       │ └─Sinatra::Application#body $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:238
    │ │       │   ├─Kernel#block_given? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:239
    │ │       │   ├─Sinatra::Request#head? $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:122
    │ │       │   │ └─Sinatra::Request#request_method $GemPath0/gems/rack-1.6.5/lib/rack/request.rb:23
    │ │       │   ├─Kernel#is_a? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:243
    │ │       │   ├─Kernel#is_a? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:243
    │ │       │   ├─Sinatra::Application#headers $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:298
    │ │       │   ├─Rack::Utils::HeaderHash#delete $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:522
    │ │       │   │ ├─String#downcase $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:523
    │ │       │   │ ├─Hash#delete $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:524
    │ │       │   │ ├─Hash#delete $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:524
    │ │       │   │ └─Hash#delete_if $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:525
    │ │       │   │   ├─Rack::Utils::HeaderHash#block in delete $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:525
    │ │       │   │   │ └─String#downcase $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:525
    │ │       │   │   └─Rack::Utils::HeaderHash#block in delete $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:525
    │ │       │   │     └─String#downcase $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:525
    │ │       │   └─Sinatra::Response#body= $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:129
    │ │       │     ├─Module#=== $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:130
    │ │       │     └─Module#=== $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:131
    │ │       ├─Sinatra::Application#settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:927
    │ │       │ ├─Kernel#class $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:928
    │ │       │ └─Sinatra::Application.settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:922
    │ │       └─Sinatra::Application#filter! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:964
    │ │         ├─Class#superclass $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:965
    │ │         ├─Kernel#respond_to? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:965
    │ │         ├─Class#superclass $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:965
    │ │         ├─Sinatra::Application#filter! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:964
    │ │         │ ├─Class#superclass $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:965
    │ │         │ ├─Kernel#respond_to? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:965
    │ │         │ └─Array#each $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:966
    │ │         └─Array#each $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:966
    │ ├─Module#=== $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1068
    │ ├─Module#=== $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1068
    │ ├─Module#=== $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1069
    │ └─Kernel#respond_to? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1074
    ├─Sinatra::Application#invoke $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1066
    │ ├─Kernel#catch $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1067
    │ │ └─Sinatra::Application#block in invoke $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1067
    │ │   └─Sinatra::Application#block in call! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:908
    │ │     └─Sinatra::Application#error_block! $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1128
    │ │       ├─Sinatra::Application#settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:927
    │ │       │ ├─Kernel#class $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:928
    │ │       │ └─Sinatra::Application.settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:922
    │ │       ├─Kernel#respond_to? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1130
    │ │       ├─Class#superclass $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1131
    │ │       ├─Kernel#respond_to? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1130
    │ │       ├─Class#superclass $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1131
    │ │       ├─Kernel#respond_to? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1130
    │ │       └─Kernel#respond_to? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1139
    │ ├─Module#=== $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1068
    │ ├─Module#=== $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1068
    │ ├─Module#=== $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1069
    │ └─Kernel#respond_to? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1074
    ├─Sinatra::Response#[] $GemPath0/gems/rack-1.6.5/lib/rack/response.rb:52
    │ └─Rack::Utils::HeaderHash#[] $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:511
    │   ├─Hash#[] $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:512
    │   ├─String#downcase $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:512
    │   └─Hash#[] $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:512
    ├─Sinatra::Application#body $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:238
    │ └─Kernel#block_given? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:239
    ├─Module#=== $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:911
    ├─Sinatra::Application#body $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:238
    │ └─Kernel#block_given? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:239
    ├─Kernel#respond_to? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:911
    ├─Sinatra::Application#content_type $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:320
    │ ├─Hash#delete $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:322
    │ ├─Sinatra::Application#mime_type $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:314
    │ │ └─Sinatra::Base.mime_type $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1312
    │ │   ├─Kernel#nil? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1313
    │ │   ├─Symbol#to_s $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1314
    │ │   ├─String#include? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1314
    │ │   ├─Symbol#to_s $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1315
    │ │   ├─String#[] $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1315
    │ │   ├─Symbol#to_s $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1315
    │ │   └─Rack::Mime.mime_type $GemPath0/gems/rack-1.6.5/lib/rack/mime.rb:16
    │ │     ├─String#to_s $GemPath0/gems/rack-1.6.5/lib/rack/mime.rb:17
    │ │     ├─String#downcase $GemPath0/gems/rack-1.6.5/lib/rack/mime.rb:17
    │ │     └─Hash#fetch $GemPath0/gems/rack-1.6.5/lib/rack/mime.rb:17
    │ ├─Kernel#nil? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:324
    │ ├─Kernel#dup $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:325
    │ │ └─Kernel#initialize_dup $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:325
    │ │   └─String#initialize_copy $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:325
    │ ├─Hash#include? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:326
    │ ├─Sinatra::Application#settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:927
    │ │ ├─Kernel#class $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:928
    │ │ └─Sinatra::Application.settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:922
    │ ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ │ └─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ ├─Enumerable#all? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:326
    │ │ └─Array#each $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:326
    │ │   ├─Sinatra::Application#block in content_type $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:326
    │ │   │ └─String#=== $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:326
    │ │   ├─Sinatra::Application#block in content_type $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:326
    │ │   │ └─String#=== $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:326
    │ │   ├─Sinatra::Application#block in content_type $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:326
    │ │   │ └─String#=== $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:326
    │ │   └─Sinatra::Application#block in content_type $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:326
    │ │     └─Regexp#=== $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:326
    │ ├─Hash#delete $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:327
    │ ├─Sinatra::Application#settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:927
    │ │ ├─Kernel#class $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:928
    │ │ └─Sinatra::Application.settings $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:922
    │ ├─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ │ └─Sinatra::Application.block in set $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:1221
    │ ├─String#include? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:329
    │ ├─String#include? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:331
    │ ├─Enumerable#map $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:332
    │ │ └─Hash#each $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:332
    │ │   └─Sinatra::Application#block in content_type $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:332
    │ │     └─Symbol#to_s $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:334
    │ ├─Array#join $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:335
    │ └─Sinatra::Response#[]= $GemPath0/gems/rack-1.6.5/lib/rack/response.rb:56
    │   └─Rack::Utils::HeaderHash#[]= $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:515
    │     ├─String#downcase $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:516
    │     └─Hash#[]= $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:519
    └─Sinatra::Response#finish $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:138
      ├─Sinatra::Response#drop_content_info? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:166
      │ ├─Integer#to_i $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:167
      │ └─Sinatra::Response#drop_body? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:170
      │   ├─Integer#to_i $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:171
      │   └─Array#include? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:171
      ├─Sinatra::Response#drop_body? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:170
      │ ├─Integer#to_i $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:171
      │ └─Array#include? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:171
      ├─Sinatra::Response#calculate_content_length? $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:162
      │ ├─Rack::Utils::HeaderHash#[] $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:511
      │ │ └─Hash#[] $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:512
      │ ├─Rack::Utils::HeaderHash#[] $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:511
      │ │ ├─Hash#[] $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:512
      │ │ ├─String#downcase $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:512
      │ │ └─Hash#[] $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:512
      │ └─Module#=== $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:163
      ├─Enumerable#inject $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:154
      │ └─Array#each $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:154
      │   └─Sinatra::Response#block in finish $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:154
      │     └─Rack::Utils.bytesize $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:379
      │       └─String#bytesize $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:380
      ├─Integer#to_s $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:154
      ├─Rack::Utils::HeaderHash#[]= $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:515
      │ ├─String#downcase $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:516
      │ └─Hash#[]= $GemPath0/gems/rack-1.6.5/lib/rack/utils.rb:519
      └─Integer#to_i $GemPath0/gems/sinatra-1.4.8/lib/sinatra/base.rb:157
```

