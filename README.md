# Zenixir
[![Build Status](https://travis-ci.org/oarrabi/zenixir.svg)](https://travis-ci.org/oarrabi/zenixir)
[![Coverage Status](https://coveralls.io/repos/oarrabi/zenixir/badge.svg?branch=master&service=github)](https://coveralls.io/github/oarrabi/zenixir?branch=master)
[![Inline docs](http://inch-ci.org/github/oarrabi/zenixir.svg)](http://inch-ci.org/github/oarrabi/zenixir)
[![Issue Count](https://codeclimate.com/github/oarrabi/zenixir/badges/issue_count.svg)](https://codeclimate.com/github/oarrabi/zenixir)
 
Elixir Zendesk API Client

## Installation
Add zenixir to your `mix.exs` deps

	def deps do
	  [{:cowboy, github: "oarrabi/zenixir"}]
	end

## Documentation
All the methods are documented, for documentation, check each of the available functions.
In iex,

`h Zendesk.CommentApi.all_comments`

## Usage
Add `use Zendesk` to your file

Create a zendesk account

```
account = Zendesk.account(subdomain: "your_subdomain",
email: "test@zendesk.com",
password: "test")
```

Pipe it (or pass it) to an api call
```
account |> all_users
```

Thats it, the above return the list of all users

Bellow is a description on how to use the provided api functions, if you don't find your function in the list you can use [Zendesk.Client](#client-request) to perform any resource request.

### Zendesk Account
Create a request with a `subdomain`, `email` and `password`:

```
account = Zendesk.account(subdomain: "your_subdomain",
email: "test@zendesk.com",
password: "test")
```

Create a request with a `subdomain`, `email` and `token`:

```
account = Zendesk.account(subdomain: "your_subdomain",
email: "test@zendesk.com",
token: "THE_TOKEN")
```

Once you have an account you can use it with all consequent api calls

### Account settings
`account_settings` returns the current account settings

Examples:

```
account |> account_settings
```

### Attachments
`upload_file` upload a file
`show_attachment` show a single attachment
`delete_attachment` deletes a single attachment

Examples:

```
account |>
upload_file(file_name: "the_file_name", file_path: "path_to_file")

account |> show_attachment(attachment_id: "Attachment_ID")

account |> delete_attachment(attachment_id: "Attachment_ID")
```

### Brand
`all_brands` get a list of all brands
`show_brand` shows a single brand

Examples:

```
account |> all_brands

account |> show_brand(brand_id: "Brand_ID")
```

### Comments
`all_comments` gets all comments for a ticket or for a request
`show_comment` shows a single comment
`redact_comment` redacts a comment
`make_comment_private` make a comment private

Examples:

```
account |> all_comments(ticket_id: "Ticket_ID")
account |> all_comments(request_id: "Request_ID")

account |> show_comment(request_id: "Request_ID",
comment_id: "Comment_ID")

account |> redact_comment(ticket_id: "Ticket_ID",
comment_id: "Comment_id", text: "text_to_redact")

account |> make_comment_private(ticket_id: "Ticket_ID",
comment_id: "Comment_id")
```

### Group membership
`all_group_membership` get a list of all group membership
`show_group_membership` shows a single group membership

Examples:

```
account |> all_group_membership
account |> all_group_membership(user_id: "User_ID")
account |> all_group_membership(group_id: "Group_ID")

account |> show_group_membership(membership_id: "Membership_ID")
account |> show_group_membership(membership_id: "Membership_ID"
user_id: "User_ID")
```

### Groups
`all_groups` get a list of all groups
`show_group` shows a single group

Examples:

```
account |> all_groups

show_group(group_id: "Group_ID")
```

### Organizations
`all_organizations` get a list of all organisations
`autocomplete_organizations` autocomplete organisation name
`show_organization` shows a single organisation

Examples:

```
account |> all_organizations
account |> all_organizations(user_id: "User_ID")

account |>autocomplete_organizations(name: "name")

account |> show_organization(organization_id: "Organization_ID")
```

### Requests
Requests are created incrementally calling, for example

```
request = Request.new(subject: "Hello", comment: "The description")
    |> Request.set_status("hold")
    |> Request.set_priority("high")
    |> Request.set_type("incident")
    |> Request.set_requester_id("222")
    |> Request.set_assignee_email("email@me.com")
    |> Request.set_group_id("333")
    |> Request.set_assignee_id("444")
    |> Request.set_due_at("at")
    |> Request.set_can_be_solved_by_me(true)
    |> Request.set_is_solved(true)
```

The returned `request` can be used to create or update a request

`all_requests` get a list of all requests
`search_requests` searches for a request with a query
`show_request` shows a request
`create_request` creates a request
`update_request` updates a request

Examples:

```
account |> all_requests
account |> all_requests(statuses: ["open", "closed"])
account |> all_requests(user_id: "4096938127")
account |> all_requests(organization_id: "22016037")

account |> search_requests(query: "the query")

account |> show_request(request_id: "Request_ID")

account |> create_request(request: a_request_struct)

account |> update_request(id: "Request_ID", request: request)
```

### Search
`search` perform a search with a query

Examples:

```
account |> search(type: :user, query: "query")
account |> search(query: "type:ticket query")
```

### Tags
`all_tags` get a list of all tags
`set_tags` set tags for a user or a ticket
`update_tags` add tags for a user or a ticket
`delete_tags` delete tags from a user or a ticket

Examples:

```
account |> all_tags
account |> all_tags(ticket_id: "Ticket_ID")
account |> all_tags(user_id: "User_ID")

account |> set_tags(user_id: "User_ID", tags: tags_list)
account |> set_tags(ticket_id: "Ticket_ID", tags: tags_list)

account |> update_tags(user_id: "User_ID", tags: tags_list)
account |> update_tags(ticket_id: "Ticket_ID", tags: tags_list)

account |> delete_tags(user_id: "User_ID", tags: tags_list)
account |> delete_tags(ticket_id: "Ticket_ID", tags: tags_list)
```

### Ticket Fields
`all_ticket_fields` get a list of all ticket fields
`create_ticket_field` create a ticket field
`update_ticket_field` update a ticket field
`delete_ticket_field` delete a ticket field

Examples:

```
account |> all_ticket_fields

field = TicketField.new(type: "tagger", title: "The title")
|> TicketField.add_custom_field_option(name: "Option 1",
value: "value1")
account |> create_ticket_field(ticket_field: field)

account |> update_ticket_field(ticket_field: field, field_id: "Field_ID")

account |> delete_ticket_field(field_id: "Field_ID")
```

### Ticket Metrics
`all_metrics` get a list of all ticket metrics
`show_metric` shows a single metric

Examples:

```
account |> all_metrics
account |> all_metrics(ticket_id: "Ticket_ID")

account |> show_metric(metric_id: "Metric_ID")
```

### Tickets
Tickets are created incrementally calling, for example

```
ticket = Ticket.new("Test Ticket")
      |> Ticket.set_priority("urgent")
      |> Ticket.set_type("problem")
      |> Ticket.set_subject("The subject")
```
The returned `ticket` can be used to create or update a ticket

`create_ticket` creates a ticket
`update_ticket` updates a ticket
`merge_tickets` merge tickets into 1 ticket
`all_tickets` return a list of all tickets
`recent_tickets` return a list of recent tickets
`delete_ticket` deletes a ticket
`ticket_related` get a ticket related info
`show_ticket` show a single ticket
`show_tickets` show multiple tickets
`ticket_collaborators` get a list of ticket collaborators
`ticket_incidents` get a list of ticket incidents
`ticket_problems` get a list of ticket problems
`autocomplete_problems` autocomplete a ticket problems

Examples:

```
account |> create_ticket(ticket: ticket)

account |> update_ticket(ticket: ticket, ticket_id: "Ticket_ID")

account |> merge_tickets(target_id: "Target_ID", ids: IDS_LIST,
target_comment: "Closing this", source_comment: "Combing")

account |> all_tickets

account |> recent_tickets

account |> delete_ticket(ticket_id: "Ticket_ID")

account |> ticket_related(ticket_id: "Ticket_ID")

account |> show_ticket(requester_id: "Request_ID")
account |> show_ticket(assignee_id: "Assignee_ID")
account |> show_ticket(cc_id: "CC_ID")
account |> show_ticket(organization_id: "Organization_ID")
account |> show_ticket(ticket_id: "Ticket_ID")

account |>  show_tickets(ids: ["1", "587"])

account |>  ticket_collaborators

account |>  ticket_incidents

account |>  ticket_problems

account |> autocomplete_problems(text: "Subject")
```

### User Fields
`all_user_fields` get a list of all user field

Examples:

```
account |> all_user_fields
```

### User
`all_users` get a list of all users
`show_user` get a single users
`show_users` get a list of users
`search_user` search for users
`autocomplete_user` autocomplete users
`current_user` get the current user

Examples:

```
account |> all_users
account |> all_users(group_id: "Group_ID")
account |> all_users(organization_id: "Organization_ID")

account |> show_user(user_id: "User_ID")

account |> show_users(ids: [ids])

account |> search_user(query: "Query")

account |> autocomplete_user(name: "Name")

account |> current_user
```

### View
Views are created incrementally calling, for example

```
view = View.new(title: "The Title")
	|> View.add_condition(type: :any, field: "status",
	operator: "is", value: "open")
	|> View.add_condition(type: :any, field: "status",
	operator: "is", value: "closed")
```
The returned `view` can be used to create or update a view

`all_views` get a list of all views
`active_views` get a list of active views
`compact_views` get a compact list of views
`show_view` show a single view
`create_view` create a view
`update_view` updates a view
`delete_view` deletes a view
`execute_view` execute a view to get the tickets
`view_tickets` get a view tickets
`count_views` count the view tickets
`count_view` count a single view tickets
`preview_view` previews a view without creating it
`count_view_preview` count the ticket number for a view preview

Examples:

```
account |> all_views

account |> active_views

account |> compact_views

account |> show_view(view_id: "View_ID")

view = View.new(title: "The Title")
|> View.add_condition(type: :any, field: "status",
operator: "is", value: "open")
account |> create_view(view)

account |> update_view(view_id: "View_ID", view: view)

account |> preview_view(view)

account |> count_view_preview(view)

account |> delete_view(view_id: "View_ID")

account |> execute_view(view_id: "View_ID")

account |> view_tickets(view_id: "View_ID")

account |> count_views(ids: [IDS])

account |> count_view(view_id: "View_ID")
```

### Client request
`Zendesk.Client` can be used to perform any request that is not listed above.

For example, for a GET request:

```
account |>
Zendesk.Client.request(resource: "organization_memberships.json")
```

A post request can be done with:

```
account |>
Client.request(resource: "tickets/1/tags.json",
verb: :post,
body: %{tags: ["1", "2"]})

account |>
Client.request(resource: "tickets/1/tags.json",
verb: :post,
json: Poison.encode!(%{tags: ["1", "2"]}) )
```

### What's supported, and what's not
The following endpoint apis are supported:

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
- Search

The following are not:

- Ticket audits
- Incremental exports
- Ticket forms
- Ticket imports
- User creations
- Create user fields
- User Identities
- Create groups
- Assign Group Memberships
- Automations
- Activity streams
- Audit logs
- Create/Delete/Update a brand
- Dynamic content
- Job statuses
- Macros
- Create/Delete Organisation
- Organisation membership

Help centre API is in the working!
