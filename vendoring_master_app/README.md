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

Fix it, by running `bundle install` again

```
$ bundle
Using bundler 2.1.4
Using nio4r 2.5.2
Using puma 4.3.3 from https://github.com/puma/puma (at /Users/dentarg/local_code/puma-vagrant/vendoring_master_app/vendor/cache/puma-6234e4b057ff@6234e4b)
/Users/dentarg/.rubies/ruby-2.6.6/lib/ruby/site_ruby/2.6.0/rubygems/ext/builder.rb:165: warning: conflicting chdir during another chdir block
/Users/dentarg/.rubies/ruby-2.6.6/lib/ruby/site_ruby/2.6.0/rubygems/ext/builder.rb:173: warning: conflicting chdir during another chdir block
Updating files in vendor/cache
Bundle complete! 1 Gemfile dependency, 3 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.

~/local_code/puma-vagrant/vendoring_master_app master* ⇡
$ bundle exec puma -C config.rb
[88087] Puma starting in cluster mode...
[88087] * Version 4.3.3 (ruby 2.6.6-p146), codename: Mysterious Traveller
[88087] * Min threads: 0, max threads: 5
[88087] * Environment: development
[88087] * Process workers: 1
[88087] * Phased restart available
[88087] * Listening on tcp://0.0.0.0:9292
[88087] Use Ctrl-C to stop
[88087] - Worker 0 (pid: 88090) booted, phase: 0
^C[88087] - Gracefully shutting down workers...
[88087] === puma shutdown: 2020-05-08 13:46:47 +0200 ===
[88087] - Goodbye!
```
