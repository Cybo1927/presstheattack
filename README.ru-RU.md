<!--
This file is part of the Press the Attack project,
Copyright (c) 2019 Bogachenko Vyacheslav

Press the Attack is a free project: You can distribute it and/or modify
it in accordance with the MIT license published by the Massachusetts Institute of Technology.

The Press the Attack project is distributed in the hope that it will be useful,
and is provided "AS IS", WITHOUT ANY WARRANTY, EXPRESSLY EXPRESSED OR IMPLIED.
WE ARE NOT RESPONSIBLE FOR ANY DAMAGES DUE TO THE USE OF THIS PROJECT OR ITS PARTS.
For more information, see the MIT license.

Github: https://github.com/bogachenko/presstheattack/
Last modified: February 13, 2019
License: MIT <https://github.com/bogachenko/presstheattack/blob/master/LICENSE.md>
Problem reports: https://github.com/bogachenko/presstheattack/issues
Title: README.ru-RU.md
URL: https://raw.githubusercontent.com/bogachenko/presstheattack/master/README.ru-RU.md
Wiki: https://github.com/bogachenko/presstheattack/wiki

Download the entire Press the Attack project at https://github.com/bogachenko/presstheattack/archive/master.zip -->

# Press the Attack
[![site](https://img.shields.io/badge/site-up-%233fb912.svg)](https://bogachenko.github.io/presstheattack/)
[![wiki](https://img.shields.io/badge/wiki-up-%233fb912.svg)](https://github.com/bogachenko/presstheattack/wiki)
[![license](https://img.shields.io/badge/license-MIT-%233fb912.svg)](https://raw.githubusercontent.com/bogachenko/presstheattack/master/LICENSE.md)
[![syntax](https://img.shields.io/badge/syntax-uBlock%20Origin-%23c61300.svg)](https://github.com/gorhill/uBlock/wiki/Static-filter-syntax)

Список фильтров для блокировки объявлений, отслеживания, майнинга и многого другого.

## O проекте

Общая цель проекта это блокировка рекламы и снижение трафика с доменов и сайтов, которые Вы посещаете.
Термин "реклама" в этом проекте не определен, потому что помимо очевидной рекламы, Я также блокирую баннеры и подсказки, которые, как Я думаю, создают бесполезный трафик.

Мой список не ограничивается каким-либо регионом. Тем не менее, Я говорю на русском и английском языках и мое внимание в основном сосредоточено на этих регионах.

## Отказ от ответственности

Я распространяю этот проект в надежде, что он будет полезен. Этот проект распространяется "КАК ЕСТЬ", без каких-либо гарантий, явных или подразумеваемых, и Я НЕ НЕСУ ОТВЕТСТВЕННОСТИ ЗА ЛЮБЫЕ УБЫТКИ, КОТОРЫЕ МОГУТ ВОЗНИКНУТЬ В РЕЗУЛЬТАТЕ ИСПОЛЬЗОВАНИЯ ЭТОГО ПРОЕКТА ИЛИ ЛЮБОЙ ЕГО ЧАСТИ.

Вы можете обнаружить, что правила в моем списке слишком усердны. Да, Я обращаю особое внимание на шпионаж и майнинг.
Однако, если Вы обнаружите, что какое-то из правил ломает сайт, отключите его и создайте [вопрос](https://github.com/bogachenko/presstheattack/issues).

Пожалуйста, обратите внимание, что Я в основном использую uBlock Origin. Я подчеркиваю это, потому что каждый браузер и плагин немного отличаются друг от друга. Этот список фильтров написан для этого плагина, и если Вы используете иной плагин для блокировки рекламы, производительность и правильная работа не гарантируется.

Почти все сетевые фильтры здесь помечены как "important" и поэтому расширения, такие как Adblock Plus и другие, заносят их в белый список или вообще не читают из-за ограничений в синтаксисе фильтров и других причин, которые меня не беспокоят.

## Использование

Чтобы начать использовать нажмите на ссылку [ПОДПИСАТЬСЯ](https://subscribe.adblockplus.org/?location=https%3A%2F%2Fraw.githubusercontent.com%2Fbogachenko%2Fpresstheattack%2Fmaster%2Fpresstheattack.txt&title=Press%20the%20Attack) или добавьте его вручную `https://raw.githubusercontent.com/bogachenko/presstheattack/master/presstheattack.txt`

## Лицензия
Этот проект имеет лицензию MIT (посмотреть [Лицензию](https://raw.githubusercontent.com/bogachenko/presstheattack/master/LICENSE.md)).

## Документация

Для ознакомления и подробного описание проекта с его документацией перейдите в раздел [ВИКИ](https://github.com/bogachenko/presstheattack/wiki).

## Вклад

Я уверен, что некоторые из фильтров здесь сломают некоторые сайты. Пожалуйста, будьте осторожны и проверьте сетевой журнал запросов (логгер) uBlock Origin, чтобы увидеть, что фильтруется, и закомментировать любой проблемный фильтр или Вы можете использовать флаг "badfilter".

Если вы хотите стать частью этого проекта, отлично, я принимаю любые просьбы о дополнительных правилах. Смело создайте "Pull request".