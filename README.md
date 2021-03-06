# Con Harvester #

This app harvests information about comic creators attending a convention and produces a [Markdown](http://daringfireball.net/projects/markdown) report.

This report can be used to quickly find comic creators that you are interested in. For instance, you may be interested in finding any artist that has been
involved in the creation of X-Men comics so that you can get an [X-Men sketch on your blank cover comic](http://yfrog.com/z/h3614svj) or grep the report
to see what comic books you should bring to the convention to get signed.

The [artists](http://www.comic-con.org/cci/cci_artalley.php) attending [Comic-Con 2013](http://www.comic-con.org/) have already been harvested in a report.
You can view that report under [examples\comic-con-2013](https://github.com/kpshek/con-harvester/tree/master/examples/comic-con-2013)

## Setup ##

### Ruby ###

To run Con Harvester you will need [Ruby](http://www.ruby-lang.org/) installed.
Con Harvester has been tested with Ruby 1.9.3p362 which is the latest version as of this writing.

### Comic Vine API Key ###

Con Harvester is built on top of the [Comic Vine API](http://www.comicvine.com/api/). As such, you will need your own API key.
If you don't have an API key, register for free as a developer at [http://www.comicvine.com/api/](http://www.comicvine.com/api/)

Once you have your API key, edit the [API-KEY](https://github.com/kpshek/con-harvester/blob/master/API-KEY) file replacing the current contents with your own API key.

### List of Comic Creators ###

The list of comic creators harvested must be provided as a plain text file named person.txt.
This file should have a single comic creator per line.

See [examples\comic-con-2013\people.txt](https://github.com/kpshek/con-harvester/blob/master/examples/comic-con-2013/people.txt) as an example.

## Running ##

To run Con Harvester, simply open a terminal session in the root directory and execute the following command:

    $ ./harvester --dir comic-con-2013 --title "Comic-Con 2013"

Where comic-con-2013 is an existing directory containing a file name people.txt containing the names of the comic creators, one per line.
This directory will also be used to write a Markdown report named README.md.

You can also view the usage help via:

    $ ./harvester --help

## Future ##

Here are things I'd like to improve:

* Harvest the data into a semantic format and then generate the report from it, allowing custom reports to be easily created/run without having to re-harvest the data

## License ##

Copyright 2013 Kevin Shekleton

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.