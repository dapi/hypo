APP=$(shell git remote show origin -n | grep 'Push  URL' | awk -F/ '{print $$2}' | awk -F. '{print $$1}')
INFRA_REPO=git@github.com:safeblock-com/infra.git 
WORKFLOW=backend-deploy.yml 
DOCKER_TAG=$(shell git describe --abbrev=0 --tags | sed -e 's/v//')
STAGE=default
SEMVER=`./bin/semver`
SLEEP=5

release-and-deploy: release deploy sleep watch

release:
	./bin/semver inc patch
	git add .semver
	git commit -m ${SEMVER}
	git push
	gh release create ${SEMVER} --generate-notes
	git pull --tags

sleep:
	sleep ${SLEEP}

deploy:
	echo "Trigger deploy for ${DOCKER_TAG}"
	gh --repo ${INFRA_REPO} workflow run ${WORKFLOW} -F tag=${SEMVER} -F app=${APP} -F stage=${STAGE}

watch:
	gh --repo ${INFRA_REPO} run list --workflow=${WORKFLOW} -L 3 -e workflow_dispatch

recreate-db:
	dropdb vilna_development || echo
	rm -f db/schema.rb
	rake db:create:primary db:migrate:primary
