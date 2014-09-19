# fluent-plugin-key-picker, a plugin for [Fluentd](http://fluentd.org)

## Component
KeyPickerOutput

Take a record and pick only the keys you want to pass

## wat?!

```
<match test.**>
  type key_picker
  keys           foo, baz
  add_tag_prefix picked.
</match>
```

And you feed such a value into fluentd:

```
"test" => {
  "foo" => "a",
  "bar" => "b",
  "baz" => "c",
  "bah" => "e",
}
```

Then you'll get re-emmited tags/records like so:

```
"picked.test" => {
  "foo" => "a",
  "baz" => "c"
}
```

## Configuration

### keys

`keys` should include the keys you want to pick.

### remove_tag_prefix, remove_tag_suffix, add_tag_prefix, add_tag_suffix

These params are included from `Fluent::HandleTagNameMixin`. See the code for details.

You must add at least one of these params.


## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-key-picker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-key-picker


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

### Copyright

Copyright (c) 2014- Carlos Donderis (@CaDs)

### License

Apache License, Version 2.0
