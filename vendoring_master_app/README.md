https://github.com/rubygems/rubygems/issues/3204

Setup:

```
bundle pack --all
```

Switch to Puma from GitHub master

```
bundle
```

Boom

```
$ bundle exec puma -C config.rb
bundler: failed to load command: puma (/Users/dentarg/.gem/ruby/2.6.6/bin/puma)
LoadError: cannot load such file -- puma/puma_http11
...
```
