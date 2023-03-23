# Easol Canvas

This gem is used to validate themes built for the Easol platform.

## Usage

### Installation
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

### The `canvas lint` command

When called inside the root of a theme directory, the `canvas lint` command will run various validation checks, such as the following:

1. RequiredFilesCheck
    - Checks that the required files exist (e.g. `templates/product/index.html`).
2. ValidHtmlCheck
    - Validates all `.html` files contain valid HTML.
3. ValidLiquidCheck
    - Validates all `.html` files contain valid Liquid.
4. ValidJsonCheck
    - Validates all `.json` files contain valid JSON.
5. ValidSassCheck
    - Validates all `.css`, `.scss` and `.sass` files contain valid Sass.
6. ValidBlockSchemasCheck
    - Validates the schema defined in each block.
7. ValidMenuSchemaCheck
    - Validates the schema defined in each menu.
8. ValidFooterSchemaCheck
    - Validates the schema defined in each footer.
9. ValidCustomTypesCheck
    - Validates each custom type defined within the `/types` directory.

### Set up a GitHub check on a theme repo

There is a [canvas-linter-action](https://github.com/easolhq/canvas-linter-action), which can be used inside an Easol theme repo to run validations on each push. Here’s an example where it is was set up in [alchemist](https://github.com/easolhq/alchemist-theme/pull/38).

Follow the instructions in the [README](https://github.com/easolhq/canvas-linter-action/blob/main/README.md) to set up this action inside your theme project.

## Developing the gem locally

### Running automated tests
You can run the tests within the repo with the following:

```
bundle
bin/rspec
```

### How to test locally in a theme repo

#### Direct call

This approach is generally quicker than installing the gem (see below). Please use the built gem for final testing.

Within a theme repo, call the executable of the gem directly, for example:

```
cd alchemist_theme
../canvas/bin/canvas lint
```

#### Installing the gem

1. Clone the [easolhq/canvas](https://github.com/easolhq/canvas) repo locally.
2. Build the gem inside the canvas directory to create a `.gem` file.

    ```
    cd canvas
    gem build
    ```

3. Install the local version of the gem (make sure this is called *inside* the canvas directory, `gem install` will look for a `.gem` file and use that instead of installing from rubygems if it exists).

    ```
    cd canvas
    gem install easol-canvas
    ```

4. Now you can use the gem within a theme repo.

    ```
    cd alchemist_theme
    canvas lint
    ```

### How to test locally within Rails

1. Clone the [easolhq/canvas](https://github.com/easolhq/canvas) repo locally.
2. Build the gem inside the canvas directory to create a `.gem` file.

    ```
    cd canvas
    gem build
    ```

3. Add the gem to the `Gemfile` in your Rails app and specify the local path.

    ```ruby
    gem "easol-canvas", path: "/path/to/canvas"
    ```

4. You can now reference the validators inside Rails, e.g.

    ```ruby
    require "canvas"

    ...

    Canvas::Validator::BlockSchema.new(schema: block_schema)
    ```

## Publishing

### How to publish a new version of the gem

1. Implement your code changes.
2. Bump the version in the code:
    1. Update the version in `lib/canvas/version.rb`.
    2. Commit these changes.
3. Push changes, wait for PR to be approved, then merge to `main`.
4. Pull the latest from `main` and then run the following rake task locally:

    ```
    rake release[origin]
    ```
    This will tag the gem, push the tag to github, build the gem, and push it to [rubygems.org](http://rubygems.org). You will need to have a RubyGem account and be added to the project.
5. On major version changes, update the version lock in the [canvas-linter-action](https://github.com/easolhq/canvas-linter-action/blob/main/entrypoint.sh) repo.
