# Тестовое задание для fullstack-разработчиков

Это задание рассчитано на 4 часа работы.

## Описание системы

В состав задания входят два сервиса: `Server` и `Calculator`

### Server

Реализует три эндпоинта: `a`, `b` и `c`:

- `a` отвечает за `1 секунду`
- `b` отвечает за `2 секунды`
- `c` отвечает за `1 секунду`

Эндпоинты можно вызывать несколько раз одновременно, но в сервере есть "защита от перегрева".

Если эндпоинт вызывается слишком интенсивно, то запрос, вызвавший перегрев, засыпает на 10 секунд, чтобы дать серверу охладится.
После завершения ожидания клиент получает корректный ответ.

Ограничения на перегрев такие:

- `a` - одновременно может выполняться `3 экземпляра`
- `b` - одновременно может выполняться `2 экземпляра`
- `c` - одновременно может выполняться `1 экземпляр`


### Calculator

Сервис предоставляет два эндпоинта: `reference` и `calculate`

Внутри `Calculator` делает последовательность взаимосвязанных вызовов к `Server`, комбинирует результаты и формирует итоговое решение.

Эндпоинт `/reference` возвращает референсное решение.

Оно формируется правильно, но очень медленно: примерно `19,5 секунд`.

Эндпоинт `/calculate` предусмотрен для вашей работы: он должен возвращать тот же результат, что `/reference`, но работать быстрее.


### Задача

В задаче две составляющих.

**Часть 1.** Сделать фронтовый интерфейс для запуска расчёта и визуализации его выполнения.

**Часть 2.** Сделать, чтобы решение строилось как можно быстрее. Spoiler: можно ускориться с исходных `19,5 секунд` до `< 7 секунд`.

В референсном решении все вызовы к серверу делаются последовательно.
Ускорения можно добиться за счёт запуска параллельных запросов.

На ваше усмотрение вы можете сделать распараллеливание на стороне сервиcа `Calculator` в эндпоинте `/calculate`, или обращаться к методам `Server` напрямую с фронта.

#### Интерфейс

В интерфейсе должна быть кнопка для запуска расчёта.

Во время выполнения или после окончательного завершения нужно вывести визуализацию выполненных запросов: в какое время отработали какие методы сервиса `Server`.

В референсоном решении все методы вызываются последовательно друг за другом, поэтому схема выглядит примерно так:

```
- a
-  bb
-    c
-     bb
-       a
time ---->
```

В вашем решении какие-то методы будут выполняться параллельно, поэтому схема может выглядеть примерно так:

```
- a
- bb
- c
-   bb
-   a
time ---->
```

### Советы

Переработать ответы сервиса `Server`, чтобы они включали не только значение, но `json` со значением, моментами старта и финиша обработки запроса.

Если вы будете ускорять запрос на стороне бэкенда, то переработать ответ эндпоинта `calculate`, чтобы он возвращал не только результат, но `json` с подробностями выполнения запросов к `Server`.

Для выбора оптимальной схемы распараллеливания очень поможет нарисовать схему взаимосвязей из референсного решения, и с её помощью найти схему организации вычислительного процесса, которая сможет уложиться в заданные рамки (с учётом защиты от перегрева).

Для ускорения на стороне бэкенда можно использовать `concurrent-ruby` или любые другие библиотеки и средства на ваше усмотрение.

Советую сделать интерфейс до того как углубляться в оптимизацию, чтобы не закопаться.

## Запуск сервисов

```bash
./start.sh # build docker images and docker-compose up
curl 0.0.0.0:9292/a
curl 0.0.0.0:9292/b
curl 0.0.0.0:9292/c

# в логе docker-compose хорошо видно, что происходит
curl 0.0.0.0:9293/reference # 0bbe9ecf251ef4131dd43e1600742cfb

docker-compose down # после завершения работы
```

## Результат

Результат работы - PR в этот репозиторий, в котором реализован фронтенд интерфейс для запуска и визуализации выполнения задачи + инструкция о том как им воспользоваться.

Для фронтенда используйте ваш основной рабочий фреймворк.

Решение должно вычисляться как можно быстрее, в идеале нужно уложиться в `< 7 секунд`.
