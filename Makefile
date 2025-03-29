recreate-db:
	dropdb vilna_development || echo
	rm -f db/schema.rb
	rake db:create:primary db:migrate:primary
