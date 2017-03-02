# app_config

Helper library for managing application config.

## Recipes

### Default

Load the `app_config` helper.

## Attributes

### Required

* `node["app_config"]["app_name"]` - The default application name used for lookups.
* `node["app_config"]["environment"]` - The node's application environment used for lookups. Defaults to `default`.
* `node["app_config"]["role"]` - The node's application role. Examples: `app`, `load`, `db`.
* `node["app_config"]["cluster"]` - The unique name for the group of servers this node is apart of. Examples: `ec2-foobar-production`, `vagrant-foobar-staging`.

### Optional

* `node["app_config"]["default_environment"]` - The default environment that is merged in to every `app_config` call's output. Defaults to `default`.
* `node["app_config"]["data_bag"]` - The default data bag used for lookups. Defaults to `app_config`.
* `node["app_config"]["override"]` - A hash of data that overrides all values from data bags.

## Usage

Create two data bags:

`app_config/zozi.json`:

```json
{
  "id": "zozi",
  "default": {
    "path": "/var/www",
    "database": {
      "adapter": "mysql2"
    }
  },
  "staging": {
    "database": {
      "name": "staging",
      "username": "staging"
    }
  },
  "ec2-staging": {
    "subdomain": "ec2-staging"
  }
}
```

`app_config/zozi_secrets.json`

```json
{
  "id": "zozi_secrets",
  "staging": {
    "database": {
      "username": "secret_user",
      "password": "donttouchmydatabaseorelse!"
    }
  }
}
```

Set some defaults for `app_config`

```ruby
default["app_config"]["app_name"] = "zozi"
default["app_config"]["environment"] = "staging"
default["app_config"]["cluster"] = "ec2-staging"
default["app_config"]["override"] = {
  "database" => {
    "username" => "override_user"
  }
}
```

Now you can do the following in your recipes:

```ruby
include_recipe "app_config"

# use defaults
app_config
# will return:
{
  "path" => "/var/www",
  "database" => {
    "adapter" => "mysql2",
    "name" => "staging",
    "username" => "override_user",
    "password" => "donttouchmydatabaseorelse!"
  },
  "subdomain" => "ec2-staging"
}

# or override the lookup params
app_config(:app_name => "new_app")
app_config(:app_name => "another_app", :environment => "production")
app_config(:data_bag => "more_app_config", :cluster => "ec2-production")
```
