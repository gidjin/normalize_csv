# NormalizeCsv

This is a tool that reads a CSV formatted file on `stdin` and emits a normalized
CSV formatted on `stdout`. This project was written on debian 9 with ruby
2.4.1, but should work on Ubuntu 16.04 LTS or macosx 10.13 the same assuming
ruby 2.4.1 or newer is installed.

It will skip over and print a warning on `stderr` for any lines it cannot process.

Requirements for what normalization process can be found in the README.instructions.md file.

## Usage

### Pre-requisite

 - On Ubuntu 16.04 LTS with ruby 2.4.1 or newer installed, and bundler gem installed
 - All commands run from this directory
 - Install dependent gems by running `bundle install` command

### Run command
To run a normalization from the command line:

```
%> cat sample.csv | bin/normalize_csv > normalized-sample.csv
```

### Run test suite

```
%> rspec spec/
```
