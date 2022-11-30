# ExampleJsonGenerator

This is a repo demonstrating how you might use Swift to define models that can be used to generate JSON that may be hosted on a configuration server.

## Building
There are 2 ways of using the executable:
1) Running through Swift (e.g. `swift run ExampleJsonGenerator`).
2) Building the executable (`swift build -c release`) and then using it directly (e.g. `./.build/release/ExampleJsonGenerator`).

## Usage
```sh
OVERVIEW: A helper for generating JSON output from Swift defined models.

USAGE: json-generate <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  build                   Encode defined Swift models into JSON and output the files into config directories.
  validate                Validate that the config files match the expected encoded output from the Swift definitions.

  See 'json-generate help <subcommand>' for detailed help.
```

The main command is:
```sh
json-generate build
```
This will encode the Swift defined models into JSON and then write them to a file within `modules/example-config/configs` directory (depending on environment).

**NOTE:** It is expected that all commands be run from the root of the repo otherwise the config paths will not be found.

To only build config for one environment you can pass a `--build-only` parameter such as below:
```sh
json-generate build --build-only int
``` 
The possible values are `int`, `int-nft`, and `prod`.

You can also validate that the existing JSON config matches the expected output from the encoded Swift models with the following:
```sh
json-generate validate
```
