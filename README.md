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

### Optional

* `node["app_config"]["default_environment"]` - The default environment that is merged in to every `app_config` call's output. Defaults to `default`.
* `node["app_config"]["data_bag"]` - The default data bag used for lookups. Defaults to `app_config`.

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
  }
}
```

`app_config/zozi_secrets.json`

```json
{
  "id": "zozi_secrets",
  "staging": {
    "database": {
      "password": "donttouchmydatabaseorelse!"
    }
  }
}
```

Set some defaults for `app_config`

```ruby
default["app_config"]["app_name"] = "zozi"
default["app_config"]["environment"] = "staging"
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
    "username" => "staging",
    "password" => "donttouchmydatabaseorelse!"
  }
}

# or override the lookup params
app_config(:app_name => "new_app")
app_config(:app_name => "another_app", :environment => "production")
app_config(:data_bag => "more_app_config")
```
