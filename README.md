# Easol Canvas

This gem is used to validate themes built for the Easol platform.

## Usage

You can install the gem globally with the following and the `canvas` command will be available:

```
gem install easol-canvas
cd my_easol_theme
canvas lint
```

Alternatively, you can add it to a Gemfile in your project and run the command using `bundle exec`:

```
cd my_easol_theme
bundle exec canvas lint
```

## Tests

You can run the tests with the following:

```
bundle
bin/rspec
```
