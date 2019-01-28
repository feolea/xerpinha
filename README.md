# Xerpinha

## Summary
- [About](https://github.com/feolea/xerpinha/#about)
- [Usage](https://github.com/feolea/xerpinha/#usage)
- [Setup](https://github.com/feolea/xerpinha/#setup)
- [Tests](https://github.com/feolea/xerpinha/#tests)
- [Comments](https://github.com/feolea/xerpinha/#helpful-links)

## About

This system was developed as a skill test.


[Back to top](https://github.com/feolea/xerpinha/#summary)

## Usage

The application will use an input file with a working period of some employees,

We have an example file at files/input.json, to use this file, after properly setup the application, run the rake task:

`rake summarizer:execute\['files/input.json'\]`

You could inform other path if you want. (relative to the root application like our example, or a full path)


[Back to top](https://github.com/feolea/xerpinha/#summary)

## Setup

This project depends on Ruby described at `.ruby-version` file, if you dont known Ruby, take a look
at [this](https://www.ruby-lang.org/en/documentation/installation/) and it is a good idea to use a manager like `rvm`, take a look [here](https://rvm.io/rvm/install).

With ruby installed,

After you've clone the project,

`$ cd xerpinha`

and

`$ bin/setup`

Done!

[Back to top](https://github.com/feolea/xerpinha/#summary)

## Tests

To run test suite, just:

`$ rspec spec`


[Back to top](https://github.com/feolea/xerpinha/#summary)

## Comments

- We do not have the Default rest interval at input file (just the minimum), so I decided to put an Default of 60 minutes, as an constant [here](https://github.com/feolea/xerpinha/blob/master/lib/services/employee_builder.rb#L21)

- I left one test skipped, and in this release I do not consider that one employee could make more than one interval at the same day.

- In case of one missing entry at a day, for example, with only three entries, I considered that the employee forgot to register one of the intervals entries, so to the calculations I have considered an interval of 60 minutes in these cases.

- In case of two missing entries, I considered that the employee did not make the pause, so the time is added if the journey was 50% or more of the daily journey.

- Basically all the business rules are described on the test files

- There are some info at some of the pull requests too (merged)

- I have to say that this challenge was fun and I learned a lot, pausing my coding sessions to decide some possible ways to solve something, usually we discuss these decisions in a team, but in this case was me and some books that helped me a lot!

### My references:

  - Practical object-oriented design in Ruby - Sandi Metz

  - Eloquent Ruby - Russ Olsen

  - Clean Code - Robert C. Martin

  - StackOverflow :)

  - Rubydocs
