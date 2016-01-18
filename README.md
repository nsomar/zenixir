# NewTest
[![Build Status](https://travis-ci.org/oarrabi/elixir-test.svg)](https://travis-ci.org/oarrabi/elixir-test)
[![Coverage Status](https://coveralls.io/repos/oarrabi/elixir-test/badge.svg?branch=master&service=github)](https://coveralls.io/github/oarrabi/elixir-test?branch=master)
[![Inline docs](http://inch-ci.org/github/oarrabi/elixir-test.svg)](http://inch-ci.org/github/oarrabi/elixir-test)
[![Issue Count](https://codeclimate.com/github/oarrabi/elixir-test/badges/issue_count.svg)](https://codeclimate.com/github/oarrabi/elixir-test)

Zendesk client library for Elixir

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add zendesk to your list of dependencies in `mix.exs`:

        def deps do
          [{:zendesk, "~> 0.0.1"}]
        end

  2. Ensure zendesk is started before your application:

        def application do
          [applications: [:zendesk]]
        end

Supported:
- Tickets operation
- Ticket comments
- Ticket fields
- Request
- User Api
- User fields api
- Group Api
- Group membership api
- Attachments
- Show Brands
- Tags
- Organisation


Unsupported:
- Ticket audits
- Incremental exports
- Ticket forms
- Ticket imports
- User creations
- Create user fields
- User Identities
- Create groups
- Assing Group Memberships
- Automations
- Activity strems
- Audit logs
- Create/Delte/Update a brand
- Dynamic content
- Job statuses
- Macros
- Create/Delete Organization
- Oragnisation membership

TODO:
- Search
