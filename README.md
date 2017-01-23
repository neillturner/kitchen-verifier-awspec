[![Gem Version](https://badge.fury.io/rb/kitchen-verifier-awspec.svg)](http://badge.fury.io/rb/kitchen-verifier-awspec)
[![Gem Downloads](http://ruby-gem-downloads-badge.herokuapp.com/kitchen-verifier-awspec?type=total&color=brightgreen)](https://rubygems.org/gems/kitchen-verifier-awspec)
[![Build Status](https://travis-ci.org/neillturner/kitchen-verifier-awspec.png)](https://travis-ci.org/neillturner/kitchen-verifier-awspec)

# Kitchen::Verifier::Awspec

A Test Kitchen Awspec Verifer.

Can be used in conjunction with kitchen-cloudformation and kitchen-terraform to validate AWS infrastructure changes.


## Installation

On your workstation add this line to your Gemfile:

    gem 'kitchen-verifier-awspec'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kitchen-verifier-awspec

When it runs it installs awspec on the workstation.
This can be configured by passing a Gemfile like this:

```
source 'https://rubygems.org'

gem 'net-ssh','~> 2.9'
gem 'awspec'
```

This allows extra dependencies to be specified and the version of awspec specified.

# Awspec Verifier Options

key | default value | Notes
----|---------------|--------
additional_install_commmand | nil | Additional shell command to be used at install stage. Can be multiline. See examples below.
additional_awspec_command | nil | additional command to run awspec. Can be multiline. See examples below.
bundler_path | | override path for bundler command
color | true | enable color in the output
custom_install_commmand | nil | Custom shell command to be used at install stage. Can be multiline. See examples below.
custom_awspec_command | nil | custom command to run awspec. Can be multiline. See examples below.
default_path | '/tmp/kitchen' | Set the default path where awspec looks for patterns
default_pattern | false | use default dir for awspec i.e. spec/*_spec.rb
env_vars | {} | environment variable to set for rspec and can be used in the spec_helper. It will automatically pickup any environment variables set with a KITCHEN_ prefix.
extra_flags | nil | extra flags to add to ther awspec command
format | 'documentation' | format of awspec output
gemfile | nil | custom gemfile to use to install awspec
http_proxy | nil | use http proxy when installing  awspec and running awspec
https_proxy | nil | use https proxy when installing awspec and running awspec
patterns | [] | array of patterns for spec test files
remove_default_path | false | remove the default_path after successful awspec run
rspec_path | | override path for rspec command
sleep | 0 |
sudo | nil | use sudo to run commands
sudo_command | 'sudo -E -H' | sudo command to run when sudo set to true
test_awspec_installed | true | only run install_command if awspec not installed


## Usage

Verifier awspec runs locally on your workstation and uses aws sdk to verify the aws resources.

Verifier Awspec allows the awspec files to be anywhere in the repository or in the awspec default location i.e /spec.

(see https://github.com/k1LoW/awspec)


## Example

.kitchen.yml file. See example directory for a full example.
```yaml
---
driver:
  name: cloudformation
  stack_name: awspecTest
  ssh_key: spec/test.pem
  template_file: EC2InstanceSample.yml
  parameters:
    KeyName: test

provisioner:
  name: dummy

platforms:
  - name: aws

verifier:
  name: awspec

suites:
  - name: base
    verifier:
      patterns:
      - spec/test_spec.rb

```

### Configure AWS credentials

Configure your local workstation with AWS credentials using one of the following methods:

#### Method 1: Configure command

Provide the values of your AWS access and secret keys, and optionally default region and output format:

```sh
$ aws configure
AWS Access Key ID [None]: AKID1234567890
AWS Secret Access Key [None]: MY-SECRET-KEY
Default region name [None]: us-west-2
Default output format [None]: text
```

#### Method 2: Config file

Write your credentials into the file `~/.aws/credentials` using the following template:

```
[default]
aws_access_key_id = AKID1234567890
aws_secret_access_key = MY-SECRET-KEY
aws_region=eu-west-1
```

#### Method 3: Environment variables

Provide AWS credentials to kube-aws by exporting the following environment variables:

```sh
export AWS_ACCESS_KEY_ID=AKID1234567890
export AWS_SECRET_ACCESS_KEY=MY-SECRET-KEY
export AWS_REGION=eu-west-1
```

(See http://docs.aws.amazon.com/ja_jp/cli/latest/userguide/cli-chap-getting-started.html#config-settings-and-precedence)

### Run test-kitchen

```
cd kitchen-verifier-awspec/example

# for windows set the ssl cert file
set SSL_CERT_FILE=C:/repository/kitchen-verifier-awspec/example/ca-bundle.crt

kitchen list

kitchen create base-aws -l debug

kitchen converge base-aws -l debug

kitchen verify base-aws -l debug

kitchen destroy base-aws -l debug
```

#### custom_install_command example usage

* One liner
```yaml
    custom_install_command: yum install -y git
```
* Multiple lines, a.k.a embed shell script
```yaml
  custom_install_command: |
     command1
     command2
```
* Multiple lines join without new line
```yaml
  custom_install_command: >
     command1 &&
     command2
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Run style checks and RSpec tests (`bundle exec rake`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
