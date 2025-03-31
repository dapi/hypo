APP=vilna 
INFRA_REPO=git@github.com:safeblock-com/infra.git 
WORKFLOW=backend-deploy.yml 
DOCKER_TAG=$(shell git describe --abbrev=0 --tags | sed -e 's/v//')

recreate-db:
	dropdb vilna_development || echo
	rm -f db/schema.rb
	rake db:create:primary db:migrate:primary

deploy:
	echo "Trigger deploy for ${DOCKER_TAG}"
	gh --repo ${INFRA_REPO} workflow run ${WORKFLOW} -F tag=${DOCKER_TAG} -F app=${APP}

watch:
	gh --repo ${INFRA_REPO} run list --workflow=${WORKFLOW}
