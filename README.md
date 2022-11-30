# ExampleJsonGenerator

This is a repo demonstrating how you might use Swift to define models that can be used to generate JSON that may be hosted on a configuration server.

## Repo Structure

The folder structure looks odd as it is demonstrating how Swift can be one tool that is used to generate configuration in a shared repository, while other teams with different language backrounds may choose to opt for another option.

The output JSON exists within the `modules/example-config/configs` directory. Each environment (`int`, `int-nft`, `prod`) has its own config that is located at `ios/config` (again indicating that there may be more than just iOS configuration in the repo).

The code for the command line tool can be found at `tools/swift/Sources/ExampleJsonGenerator`. Within this directory, the code that defines the configuration to be generated is found within the `Configuration` directory, and the code that handles the JSON generation is found within `Generator`. You can play with what values get generated in each environment via `Configuration/Configuration.swift` and you can alter the structure of the configuration via `Configuration/ConfigurationModel.swift`. 

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
