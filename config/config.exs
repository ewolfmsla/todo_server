import Config

config :todo_server, env: Mix.env()

config :todo_server, wolf: Wolf
config :todo_server, database: Todo.Database

import_config "#{config_env()}.exs"
