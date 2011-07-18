# Con Harvester #

This app harvests information about comic creators attending a convention and produces a [Markdown](http://daringfireball.net/projects/markdown) report.

The [artists](http://www.comic-con.org/cci/cci_artalley.php) attending [Comic-Con 2011](http://www.comic-con.org/) have already been harvested in a report.
You can view that report under [examples\comic-con-2011](https://github.com/kpshek/con-harvester/tree/master/examples/comic-con-2011)

## Setup ##

### Groovy ###

To run Con Harvester you will need [Groovy](http://groovy.codehaus.org/Download) installed.
Con Harvester has been tested with Groovy 1.8.0 which is the latest version as of this writing.

### Comic Vine API Key ###

Con Harvester is built on top of the [Comic Vine API](http://api.comicvine.com/). As such, you will need your own API key.
If you don't have an API key, register for free as a developer at http://api.comicvine.com/

Once you have your API key, edit the [API-KEY](https://github.com/kpshek/con-harvester/blob/master/API-KEY) file replacing the current contents with your own API key.

### List of Comic Creators ###

The list of comic creators harvested must be provided as a plain text file named person.txt.
This file should have a single comic creator per line.

See [examples\comic-con-2011\people.txt](https://github.com/kpshek/con-harvester/blob/master/examples/comic-con-2011/people.txt) as an example.

## Running ##

To run Con Harvester, simply open a terminal session in the root directory and execute the following command:

    $ groovy -cp . harvester -dir comic-con-2011 -title "Comic-Con 2011"

Where comic-con-2011 is an existing directory containing a file name people.txt containing the names of the comic creators, one per line.
This directory will also be used to write a Markdown report named README.md.

You can also view the usage help via:

    $ groovy -cp . harvester -help

## License ##

Copyright 2011 Kevin Shekleton

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.