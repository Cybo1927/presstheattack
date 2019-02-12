<!--
This file is part of the Press the Attack project,
Copyright (c) 2019 Bogachenko Vyacheslav

Press the Attack is a free project: you can distribute it and/or modify
it in accordance with the MIT license published by the Massachusetts Institute of Technology.

The Press the Attack project is distributed in the hope that it will be useful,
and is provided "AS IS", WITHOUT ANY WARRANTY, EXPRESSLY EXPRESSED OR IMPLIED.
WE ARE NOT RESPONSIBLE FOR ANY DAMAGES DUE TO THE USE OF THIS PROJECT OR ITS PARTS.
For more information, see the MIT license.

Github: https://github.com/bogachenko/presstheattack/
Last modified: February 13, 2019
License: MIT <https://github.com/bogachenko/presstheattack/blob/master/LICENSE.md>
Problem reports: https://github.com/bogachenko/presstheattack/issues
Title: README.md
URL: https://raw.githubusercontent.com/bogachenko/presstheattack/master/README.md
Wiki: https://github.com/bogachenko/presstheattack/wiki

Download the entire Press the Attack project at https://github.com/bogachenko/presstheattack/archive/master.zip -->

# Press the Attack
[![site](https://img.shields.io/badge/site-up-%233fb912.svg)](https://bogachenko.github.io/presstheattack/)
[![wiki](https://img.shields.io/badge/wiki-up-%233fb912.svg)](https://github.com/bogachenko/presstheattack/wiki)
[![license](https://img.shields.io/badge/license-MIT-%233fb912.svg)](https://raw.githubusercontent.com/bogachenko/presstheattack/master/LICENSE.md)
[![syntax](https://img.shields.io/badge/syntax-uBlock%20Origin-%23c61300.svg)](https://github.com/gorhill/uBlock/wiki/Static-filter-syntax)

Filter list for ad blocking, tracking, mining, and more.

## About the project

The overall goal of the project is to block ads and reduce traffic from the domains and sites You visit.
The term "advertising" is not defined in this project, because apart from the obvious advertising, I also block banners and tips that I think create useless traffic.

My list is not limited to any region. However, I speak Russian and English and my focus is mainly on these regions.

## Denial of responsibility

I am distributing this project in the hope that it will be useful. This project is distributed "AS IS", without any guarantees, express or implied, and I AM NOT RESPONSIBLE FOR ANY DAMAGES THAT MAY RESULT FROM THE USE OF THIS PROJECT OR ANY PART OF IT.

You may find that the rules on my list are too diligent. Yes, I pay special attention to espionage and mining.
However, if you find that any of the rules are breaking the site, disable it and create a [question](https://github.com/bogachenko/presstheattack/issues).

Please note that I mainly use uBlock Origin. I emphasize this because each browser and plugin is slightly different from each other. This filter list is written for this plugin, and if you use a different plugin to block ads, performance and correct operation is not guaranteed.

Almost all network filters here are marked as "important" and therefore extensions such as Adblock Plus and others put them on a white list or not read at all due to limitations in the filter syntax and other reasons that do not bother me.

## Usage

To start using click on the link [SUBSCRIBE](https://subscribe.adblockplus.org/?location=https%3A%2F%2Fraw.githubusercontent.com%2Fbogachenko%2Fpresstheattack%2Fmaster%2Fpresstheattack.txt&title=Press%20the%20Attack) or add it manually `https://raw.githubusercontent.com/bogachenko/presstheattack/master/presstheattack.txt`

## License
This project has an MIT license (see [License](https://raw.githubusercontent.com/bogachenko/presstheattack/master/LICENSE.md)).

## Documentation

For acquaintance and the detailed description of the project with its documentation pass into the section [WIKI](https://github.com/bogachenko/presstheattack/wiki).

## Contributions

I'm sure some of the filters here will break some sites. Please be careful and check the network request log (logger) of uBlock Origin to see what is being filtered and comment out any problem filter or you can use the "badfilter" flag.

If you want to be part of this project, fine, I accept any requests for additional rules. Feel free to create "Pull request".