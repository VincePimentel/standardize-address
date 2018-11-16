# Standardize Address

Address standardization is the process of formatting an address so that it matches the approved format of the national postal authority. The USPS determines the official format for addresses in the United States.

## Installation

Clone this repo via:

```
git clone git@github.com:VincePimentel/standardize-address.git
```

## Usage

This gem utilizes the USPS Web Tools API so a username is required. To request one, click [here](https://www.usps.com/business/web-tools-apis/web-tools-registration.htm). After acquiring a username, head to `lib/standardize_address.rb` and put your username under `#username`.

Run the program by typing the following at the root directory (standardize-address):

```
$ ruby bin/start
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/VincePimentel/standardize-address.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
