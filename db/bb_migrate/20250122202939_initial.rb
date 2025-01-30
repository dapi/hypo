class Initial < ActiveRecord::Migration[8.0]
  def up
    # Запускаем на уже существующей базе
    return if table_exists? :blockchain_events
    # Custom types defined in this database.
    # Note that some types may not work with other database engines. Be careful if changing database.
    create_enum "project_extension_name", [ "abi", "new_contract", "dataset_filter" ]

    create_table "blockchain_events", primary_key: [ "blockchain_id", "identifier", "partition" ], comment: "Stores information about blockchain events, including their identifiers, partitions, and block data in a bit set.", options: "PARTITION BY LIST (blockchain_id)", force: :cascade do |t|
      t.integer "blockchain_id", null: false, comment: "Composite primary key to ensure uniqueness and optimize querying."
      t.string "identifier", limit: 128, null: false, comment: "Unique identifier of the event (e.g., topic0 in Ethereum) within a specific blockchain."
      t.integer "partition", limit: 2, null: false, comment: "Partition number used for storing block data in segments."
      t.bit_varying "bits", limit: 100000, null: false, comment: "Bit set representing blocks (1 indicates the presence of an event, 0 indicates its absence)."
      t.integer "total_events", null: false, comment: "The total number of events recorded in the given range (not individual blocks)."
      t.index [ "blockchain_id", "partition", "identifier" ], name: "blockchain_events_blockchain_partition_identifier_idx"
    end

    create_table "blockchain_events_arbitrum", primary_key: [ "blockchain_id", "identifier", "partition" ], options: "INHERITS (blockchain_events)", force: :cascade do |t|
      t.integer "blockchain_id", null: false
      t.string "identifier", limit: 128, null: false
      t.integer "partition", limit: 2, null: false
      t.bit_varying "bits", limit: 100000, null: false
      t.integer "total_events", null: false
      t.index [ "blockchain_id", "partition", "identifier" ], name: "blockchain_events_arbitrum_blockchain_id_partition_identifi_idx"
    end

    create_table "blockchain_events_avalanche", primary_key: [ "blockchain_id", "identifier", "partition" ], options: "INHERITS (blockchain_events)", force: :cascade do |t|
      t.integer "blockchain_id", null: false
      t.string "identifier", limit: 128, null: false
      t.integer "partition", limit: 2, null: false
      t.bit_varying "bits", limit: 100000, null: false
      t.integer "total_events", null: false
      t.index [ "blockchain_id", "partition", "identifier" ], name: "blockchain_events_avalanche_blockchain_id_partition_identif_idx"
    end

    create_table "blockchain_events_base", primary_key: [ "blockchain_id", "identifier", "partition" ], options: "INHERITS (blockchain_events)", force: :cascade do |t|
      t.integer "blockchain_id", null: false
      t.string "identifier", limit: 128, null: false
      t.integer "partition", limit: 2, null: false
      t.bit_varying "bits", limit: 100000, null: false
      t.integer "total_events", null: false
      t.index [ "blockchain_id", "partition", "identifier" ], name: "blockchain_events_base_blockchain_id_partition_identifier_idx"
    end

    create_table "blockchain_events_binance", primary_key: [ "blockchain_id", "identifier", "partition" ], options: "INHERITS (blockchain_events)", force: :cascade do |t|
      t.integer "blockchain_id", null: false
      t.string "identifier", limit: 128, null: false
      t.integer "partition", limit: 2, null: false
      t.bit_varying "bits", limit: 100000, null: false
      t.integer "total_events", null: false
      t.index [ "blockchain_id", "partition", "identifier" ], name: "blockchain_events_binance_blockchain_id_partition_identifie_idx"
    end

    create_table "blockchain_events_ethereum", primary_key: [ "blockchain_id", "identifier", "partition" ], options: "INHERITS (blockchain_events)", force: :cascade do |t|
      t.integer "blockchain_id", null: false
      t.string "identifier", limit: 128, null: false
      t.integer "partition", limit: 2, null: false
      t.bit_varying "bits", limit: 100000, null: false
      t.integer "total_events", null: false
      t.index [ "blockchain_id", "partition", "identifier" ], name: "blockchain_events_ethereum_blockchain_id_partition_identifi_idx"
    end

    create_table "blockchain_events_optimism", primary_key: [ "blockchain_id", "identifier", "partition" ], options: "INHERITS (blockchain_events)", force: :cascade do |t|
      t.integer "blockchain_id", null: false
      t.string "identifier", limit: 128, null: false
      t.integer "partition", limit: 2, null: false
      t.bit_varying "bits", limit: 100000, null: false
      t.integer "total_events", null: false
      t.index [ "blockchain_id", "partition", "identifier" ], name: "blockchain_events_optimism_blockchain_id_partition_identifi_idx"
    end

    create_table "blockchain_events_polygon", primary_key: [ "blockchain_id", "identifier", "partition" ], options: "INHERITS (blockchain_events)", force: :cascade do |t|
      t.integer "blockchain_id", null: false
      t.string "identifier", limit: 128, null: false
      t.integer "partition", limit: 2, null: false
      t.bit_varying "bits", limit: 100000, null: false
      t.integer "total_events", null: false
      t.index [ "blockchain_id", "partition", "identifier" ], name: "blockchain_events_polygon_blockchain_id_partition_identifie_idx"
    end

    create_table "blockchains", id: { type: :integer, comment: "Unique identifier for the blockchain (ethereum: 1, binance: 56).", default: nil }, comment: "Stores information about supported blockchains, including their names, abbreviations, and metadata.", force: :cascade do |t|
      t.string "name", null: false, comment: "Unique short name of the blockchain (e.g., ethereum)."
      t.string "short_name", null: false, comment: "Abbreviation for the blockchain (e.g., eth for Ethereum)."
      t.string "full_name", null: false, comment: "Full name of the blockchain (e.g., Ethereum)."
      t.bigint "latest_block_number", default: 0, null: false, comment: "The latest processed block number to track progress."
      t.string "image_path", null: false, comment: "Path to the blockchain logo, e.g., networks/ethereum.svg."
      t.datetime "updated_at", precision: nil, default: -> { "timezone('utc'::text, now())" }, null: false, comment: "Timestamp of the last update in UTC timezone."

      t.unique_constraint [ "full_name" ], name: "blockchains_full_name_key"
      t.unique_constraint [ "image_path" ], name: "blockchains_image_path_key"
      t.unique_constraint [ "name" ], name: "blockchains_name_key"
      t.unique_constraint [ "short_name" ], name: "blockchains_short_name_key"
    end

    create_table "project_api_keys", id: { type: :uuid, comment: "Unique identifier for the API key.", default: nil }, comment: "Stores API keys associated with projects, including their hashed values, expiration dates, and creation details.", force: :cascade do |t|
      t.uuid "project_id", null: false, comment: "Reference to the project the API key is associated with. Uses ON DELETE CASCADE to remove the key when the project is deleted."
      t.uuid "creator_id", null: false, comment: "Reference to the user who created the API key. Uses ON DELETE CASCADE to remove the key when the user is deleted."
      t.binary "secret_hash", null: false, comment: "Hashed value of the secret API key. Must be unique across all records."
      t.datetime "expired_at", precision: nil, comment: "Optional timestamp indicating when the API key expires."
      t.datetime "created_at", precision: nil, default: -> { "timezone('utc'::text, now())" }, null: false, comment: "Timestamp indicating when the API key record was created, stored in UTC timezone."
      t.index [ "project_id", "secret_hash", "expired_at" ], name: "project_api_keys_project_id_secret_hash_expired_at_key"
      t.unique_constraint [ "secret_hash" ], name: "project_api_keys_secret_hash_key"
    end

    create_table "project_extensions", id: { type: :uuid, comment: "Unique identifier for the project extension.", default: nil }, comment: "Stores extensions applied to projects, including their metadata, type, and parameters.", force: :cascade do |t|
      t.integer "blockchain_id", null: false, comment: "Reference to the blockchain associated with the extension. Uses ON DELETE CASCADE to remove the extension if the blockchain is deleted."
      t.uuid "project_id", null: false, comment: "Reference to the project associated with the extension. Uses ON DELETE CASCADE to remove the extension if the project is deleted."
      t.string "title", limit: 32, null: false, comment: "User-defined title for the extension."
      t.string "summary", limit: 128, comment: "Brief description of the extension, providing additional context."
      t.string "tag", limit: 32, null: false, comment: "Is responsible for dividing extensions into groups. By default is the name of the extension."
      t.enum "name", null: false, comment: "Type of the extension, defined by the project_extension_name enum.", enum_type: "project_extension_name"
      t.jsonb "params", null: false, comment: "JSON object containing parameters for configuring the extension."
      t.string "extra_dataset_paths", default: [], null: false, comment: "An array of dataset paths that will be added when filtering the payload. Specified in the format <KEY_0>.<KEY_1>[.<KEY_N>]. Example: \"eth_getBlockByNumber.transactions.accessList.address\"", array: true
    end

    create_table "projects", id: { type: :uuid, comment: "Unique identifier for the project.", default: nil }, comment: "Stores information about user-created projects, including their names and timestamps for creation and updates.", force: :cascade do |t|
      t.string "name", limit: 128, null: false, comment: "Name of the project, defined by the user."
      t.datetime "created_at", precision: nil, default: -> { "timezone('utc'::text, now())" }, null: false, comment: "Timestamp indicating when the project record was created, stored in UTC timezone."
      t.datetime "updated_at", precision: nil, default: -> { "timezone('utc'::text, now())" }, null: false, comment: "Timestamp indicating when the project record was last updated, stored in UTC timezone."
    end

    create_table "service_events", id: { type: :uuid, comment: "Unique identifier for the service event.", default: nil }, comment: "Stores events processed by services, including the last processed block and timestamps for creation and updates.", force: :cascade do |t|
      t.uuid "service_id", null: false, comment: "Reference to the service associated with the event. Uses ON DELETE CASCADE to remove the event when the service is deleted."
      t.bigint "current_block", default: 0, null: false, comment: "The last processed block number for this event."
      t.datetime "created_at", precision: nil, default: -> { "timezone('utc'::text, now())" }, null: false, comment: "Timestamp indicating when the service event was created, stored in UTC timezone."
      t.datetime "updated_at", precision: nil, default: -> { "timezone('utc'::text, now())" }, null: false, comment: "Timestamp indicating when the service event was last updated, stored in UTC timezone."
    end

    create_table "service_events_project_extensions", id: false, comment: "Links service events with project extensions, allowing for additional functionality and configuration per event.", force: :cascade do |t|
      t.uuid "service_event_id", null: false, comment: "Reference to the associated service event. Uses ON DELETE CASCADE to remove the record when the service event is deleted."
      t.uuid "project_extension_id", null: false, comment: "Reference to the associated project extension. Uses ON DELETE RESTRICT to prevent deletion of the extension while it is linked to a service event."
      t.index [ "service_event_id", "project_extension_id" ], name: "service_events_project_extensions_id_key"
    end

    create_table "services", id: { type: :uuid, comment: "Unique identifier for the service.", default: nil }, comment: "Stores information about services linked to projects and blockchains, including their configuration and status.", force: :cascade do |t|
      t.string "name", limit: 32, null: false, comment: "Name of the service, provided by the user."
      t.uuid "project_id", null: false, comment: "Reference to the project associated with the service. Uses ON DELETE CASCADE to remove the service when the project is deleted."
      t.integer "blockchain_id", null: false, comment: "Reference to the blockchain associated with the service. Uses ON DELETE CASCADE to remove the service when the blockchain is deleted."
      t.boolean "webhook_is_active", default: false, null: false, comment: "Indicates whether the webhook for data transmission is currently active."
      t.string "webhook_url", limit: 128, null: false, comment: "URL address used for sending webhook data."
      t.boolean "is_active", default: false, null: false, comment: "Indicates whether the service is currently active. If false, the service is inactive."
      t.string "extra_dataset_paths", default: [], null: false, comment: "An array of dataset paths that will be added when filtering the payload. Specified in the format <KEY_0>.<KEY_1>[.<KEY_N>]. Example: \"eth_getBlockByNumber.transactions.accessList.address\"", array: true
      t.datetime "created_at", precision: nil, default: -> { "timezone('utc'::text, now())" }, null: false, comment: "Timestamp indicating when the service was created, stored in UTC timezone."
      t.datetime "updated_at", precision: nil, default: -> { "timezone('utc'::text, now())" }, null: false, comment: "Timestamp indicating when the service was last updated, stored in UTC timezone."
    end

    create_table "user_projects", id: { type: :uuid, comment: "Unique identifier for the user-project relationship.", default: nil }, comment: "Links users to projects, indicating access rights and tracking the creation of associations.", force: :cascade do |t|
      t.uuid "project_id", null: false, comment: "Reference to the associated project. Uses ON DELETE CASCADE to remove the relationship when the project is deleted."
      t.uuid "user_id", null: false, comment: "Reference to the associated user."
      t.datetime "created_at", precision: nil, default: -> { "timezone('utc'::text, now())" }, null: false, comment: "Timestamp indicating when the user-project relationship was created, stored in UTC timezone."

      t.unique_constraint [ "project_id", "user_id" ], name: "user_projects_project_id_user_id_key"
    end

    create_table "users", id: { type: :uuid, comment: "Unique identifier for the user.", default: nil }, comment: "Stores information about system users, including their unique email addresses and timestamps for creation and updates.", force: :cascade do |t|
      t.string "email", limit: 64, null: false, comment: "Unique email address of the user."
      t.datetime "created_at", precision: nil, default: -> { "timezone('utc'::text, now())" }, null: false, comment: "Timestamp indicating when the user record was created, stored in UTC timezone."
      t.datetime "updated_at", precision: nil, default: -> { "timezone('utc'::text, now())" }, null: false, comment: "Timestamp indicating when the user record was last updated, stored in UTC timezone."

      t.unique_constraint [ "email" ], name: "users_email_key"
    end

    add_foreign_key "blockchain_events", "blockchains", name: "blockchain_events_blockchain_id_fkey", on_delete: :cascade
    add_foreign_key "blockchain_events_arbitrum", "blockchains", name: "blockchain_events_blockchain_id_fkey", on_delete: :cascade
    add_foreign_key "blockchain_events_avalanche", "blockchains", name: "blockchain_events_blockchain_id_fkey", on_delete: :cascade
    add_foreign_key "blockchain_events_base", "blockchains", name: "blockchain_events_blockchain_id_fkey", on_delete: :cascade
    add_foreign_key "blockchain_events_binance", "blockchains", name: "blockchain_events_blockchain_id_fkey", on_delete: :cascade
    add_foreign_key "blockchain_events_ethereum", "blockchains", name: "blockchain_events_blockchain_id_fkey", on_delete: :cascade
    add_foreign_key "blockchain_events_optimism", "blockchains", name: "blockchain_events_blockchain_id_fkey", on_delete: :cascade
    add_foreign_key "blockchain_events_polygon", "blockchains", name: "blockchain_events_blockchain_id_fkey", on_delete: :cascade
    add_foreign_key "project_api_keys", "projects", name: "project_api_keys_project_id_fkey", on_delete: :cascade
    add_foreign_key "project_api_keys", "users", column: "creator_id", name: "project_api_keys_creator_id_fkey", on_delete: :cascade
    add_foreign_key "project_extensions", "blockchains", name: "project_extensions_blockchain_id_fkey", on_delete: :cascade
    add_foreign_key "project_extensions", "projects", name: "project_extensions_project_id_fkey", on_delete: :cascade
    add_foreign_key "service_events", "services", name: "service_events_service_id_fkey", on_delete: :cascade
    add_foreign_key "service_events_project_extensions", "project_extensions", name: "service_events_project_extensions_project_extension_id_fkey", on_delete: :restrict
    add_foreign_key "service_events_project_extensions", "service_events", name: "service_events_project_extensions_service_event_id_fkey", on_delete: :cascade
    add_foreign_key "services", "blockchains", name: "services_blockchain_id_fkey", on_delete: :cascade
    add_foreign_key "services", "projects", name: "services_project_id_fkey", on_delete: :cascade
    add_foreign_key "user_projects", "projects", name: "user_projects_project_id_fkey", on_delete: :cascade
    add_foreign_key "user_projects", "users", name: "user_projects_user_id_fkey"
  end
end
