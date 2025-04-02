#### Публичные методы

/users создание пользователей

#### Токен авторизации (user_id)

get /projects возвращает список проектов пользователя (limit, order, page)
get /project/:id получить проект
patch /project/:id/rename изменить имя проекта
delete /projects/:id удалить проект

get /projects/:id/users получить пользователей проекта
post /projects/:id/users создать
delete /projects/:id/users удалить

get /project/:id/extensions получить список расширений (limit, order, page)
get /project/:id/extensions/:id просмотр
patch /project/:id/extensions обновление полей
delete /project/:id/extensions + ошибка если он где то используется

# ОБНОВИТЬ МИГРАЦИИ
# + добавить имя ключа

get projects/:id/api_keys получить список api ключей (limit, order, page)
post projects/:id/api_keys создать API ключ (name, expired_at)
patch projects/:id/api_keys/rename изменить имя
delete projects/:id/api_keys удалить

# ОБНОВИТЬ МИГРАЦИИ
# убрать webhook_is_active, webhook_url, убрать таблицу service_events, добавим current_block в services из service_events
# изменить таблицу service_events_project_extensions теперь относится к services

get /projects/:id/services получить список сервисов (limit, order, page)
post /projects/:id/services создать сервис (extensions: [], )

delete /services/:id удалить сервис
patch /services/:id/disable выключить сервис
patch /services/:id/enable включить сервис
patch /services/:id обновить общие настройки extra_dataset_paths, name

get /projects/:id/services/:id/current_block
path /projects/:id/services/:id/current_block

get /services/:id/extensions список
post /services/:id/extensions добавить один
delete /services/:id/extensions удалить один


--- API KEY


get /blockchains/:id/latest - возвращает последний блок в сети

post /blockchains/:id/blocks/{start_block}/indexes - возвращает индексы по identifiers
post /blockchains/:id/blocks/{number}/dataset - парсит блок, с помощью extensions (entity)

get /services/:id/blocks/{start_block}/indexes - возвращает индексы по identifiers из extensions сервиса
get /services/:id/blocks/{number}/dataset - парсит блок, с помощью extensions сервиса
