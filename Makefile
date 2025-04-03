APP=$(shell git remote show origin -n | grep 'Push  URL' | awk -F/ '{print $$2}' | awk -F. '{print $$1}')
INFRA_REPO=git@github.com:safeblock-com/infra.git 
WORKFLOW=backend-deploy.yml 
DOCKER_TAG=`git describe --abbrev=0 --tags | sed -e 's/v//'`
STAGE=default
SEMVER=`./bin/semver`
SLEEP=5
GH=gh --repo ${INFRA_REPO}
LATEST_RUN_ID=`${GH} run list --workflow=backend-deploy.yml  -L 3 -e workflow_dispatch --json databaseId -q.[0].databaseId`

release-and-deploy: release deploy sleep watch

bump:
	@./bin/semver inc patch
	@echo "Increment version to ${SEMVER}"
	@git add .semver
	@git commit -m ${SEMVER}
	@git push

release: bump push-release

push-release:
	@gh release create ${SEMVER} --generate-notes
	@git pull --tags

sleep:
	@echo "Wait ${SLEEP} seconds for workflow to run"
	@sleep ${SLEEP}

deploy:
	@echo "Trigger deploy for ${DOCKER_TAG}"
	@${GH} workflow run ${WORKFLOW} -F tag=${DOCKER_TAG} -F app=${APP} -F stage=${STAGE}

watch:
	@${GH} run watch ${LATEST_RUN_ID}

view:
	@${GH} run view ${LATEST_RUN_ID} --log-failed

list:
	@${GH} run list --workflow=${WORKFLOW} -L 3 -e workflow_dispatch

recreate-db:
	dropdb vilna_development || echo
	rm -f db/schema.rb
	rake db:create:primary db:migrate:primary
