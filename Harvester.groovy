/*
 * Copyright 2011 Kevin Shekleton
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

@Grab(group='net.sf.json-lib', module='json-lib', version='2.4', classifier='jdk15')
import net.sf.json.*

def cli = new CliBuilder(usage:'harvester [options]', header:'Options:')
cli.with {
    dir(args:1, argName:'dir', required:true, 'The working directory containing people.txt and where the README.md will be written')
    title(args:1, argName:'title', required:true, 'The report title')
    help('Prints this message')
    setWidth(120)
    setFooter("""\
    \nExample:
    \$ harvester -dir comic-con-2011 -title "Comic-Con 2011"

    Con Harvester will open comic-con-2011/person.txt and start harvesting information about each person,
    generating the comic-con-2011/README.md report in the process.
    """)
}

def options = cli.parse(args)
if (!options) {
    return
}

if (options.help) {
    cli.usage()
    return
}

net.sf.json.groovy.GJson.enhanceString()
Utils.addMetaMethods()

def report = new File("${options.dir}/README.md")
def reporter = new Reporter(report, options.title)

new File("${options.dir}/people.txt").eachLine('UTF-8') {
    def person = Person.find(it)
    if (person) {
        reporter.log(person)
    }
}
