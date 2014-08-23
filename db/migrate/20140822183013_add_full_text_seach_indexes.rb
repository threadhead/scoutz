class AddFullTextSeachIndexes < ActiveRecord::Migration
  def up
    # events
    execute "CREATE INDEX events_name_ft ON events USING gin(to_tsvector('english', name));"
    execute "CREATE INDEX events_message_ft ON events USING gin(to_tsvector('english', message));"
    execute "CREATE INDEX events_location_name_ft ON events USING gin(to_tsvector('english', location_name));"

    #users
    execute "CREATE INDEX users_first_name_ft ON users USING gin(to_tsvector('english', first_name));"
    execute "CREATE INDEX users_last_name_ft ON users USING gin(to_tsvector('english', last_name));"

  end

  def down
    #events
    execute "DROP INDEX events_name_ft;"
    execute "DROP INDEX events_message_ft;"
    execute "DROP INDEX events_location_name_ft;"

    #users
    execute "DROP INDEX users_first_name_ft;"
    execute "DROP INDEX users_last_name_ft;"
  end
end
