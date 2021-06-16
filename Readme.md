# Дз №2. Infrastructure as Code. Ansible. Конфигурируем веб-сервис.

## Задание
Вашей задачей будет настроить простой веб-сервис с помощью Ansible. Для этого вам предлагается дописать недостающий код Ansible-роли `hello_webservice`, структура которой уже инициализирована и уже ждет вас в соответствующем [каталоге](hello_webservice).

Настройки задаваемые ролью должны зависеть от значения Ansible-переменной `hello_pages`, которая по дефолту содержит лист `['world', 'test', 'toast', 'mda']` (**NB** в тестах, очевидно, этот список будет другим) 

Для каждой строки `s` в этом списке, должно быть запущено наше тестовое приложение (см. [app.py](app/app.py)), которое вы можете править как угодно. Главное чтобы оно возвращало простой ответ `Hello s!`, и чтобы на него перенаправлялись все запросы вида `/s`, например: 

```bash
vagrant@devops:~$ curl localhost/test
Hello test!
vagrant@devops:~$ curl localhost/world
Hello world!
```

Для строк, не входящих в этот список, нужно возвращать 404
```bash
vagrant@devops:~$ curl localhost/notfound
<html>
<head><title>404 Not Found</title></head>
<body bgcolor="white">
<center><h1>404 Not Found</h1></center>
<hr><center>nginx/1.14.0 (Ubuntu)</center>
</body>
</html>
```

## Пояснения и подсказки
Чтобы пройти тесты, приложение должно запускаться при старте машины, настройте для этого systemd-сервис, по [примеру с занятия](https://git.vogres.tech/hse_devops_2021/examples/-/tree/master/iac/application_setup). Ориентируйтесь на этот пример, в нем уже есть больше половины решения. В качестве примера работы с ролями, можете использовать [пример с ролью docker](https://git.vogres.tech/hse_devops_2021/examples/-/tree/master/iac/using_roles) 

## Процесс сдачи и сроки
Чтобы сдать задание — создайте merge request из любой ветки содержащей код вашего решения в `master`. После этого запустится CI-джоба, которая прогонит тесты и если все хорошо то не грохнется, что и будет означать что вы успешно сдали ДЗ. Дата и время сдачи останется в логе джобы.

Конфиг CI берется из другого репозитория и может меняться. В том числе, могут добавляться новые тесты , поэтому чем раньше сделаете тем проще будет сдать ДЗ.

### Запуск тестов локально
Можете воспользоваться скриптом [local_test.sh](local_test.sh) чтобы запустить те же тесты, что и в CI-джобе, но у себя а не на нашем гитлабе. Так можно будет непосредственно исследовать что же сломалось. Для запуска потребуются: bash, Ansible.

## Разные ссылки
* [Документация по встроенным модулям Ansible](https://docs.ansible.com/ansible/2.10/collections/ansible/builtin/index.html#plugins-in-ansible-builtin)
* [Про модуль template](https://www.youtube.com/watch?v=tcP_gxOo7mk)
* [Введение в шаблонизацию на jinja2](https://www.youtube.com/watch?v=bxhXQG1qJPM&t=1s)
* [Туториал по systemd](https://www.digitalocean.com/community/tutorials/systemd-essentials-working-with-services-units-and-the-journal)
* [Туториал по nginx](https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-18-04)
* [Введение в HTTP](https://katiekodes.com/http-intro/)