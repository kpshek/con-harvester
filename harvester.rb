#!/usr/bin/env ruby

# Copyright 2012 Kevin Shekleton
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'optparse'
require_relative 'issue'
require_relative 'person'
require_relative 'reporter'
require_relative 'utils'
require_relative 'volume'

options = {}

opt_parser = OptionParser.new do |opt|
  opt.banner = 'Usage: harvester [options]'
  opt.separator ''
  opt.separator 'Options:'

  opt.on('-d', '--dir DIRECTORY', 'The working directory containing people.txt and where the README.md will be written') do |directory|
    options[:directory] = directory
  end

  opt.on('-t', '--title TITLE', 'The report title') do |title|
    options[:title] = title
  end

  opt.on('-h', '--help', 'Shows this message') do
    puts opt
    exit
  end

  opt.separator ''
  opt.separator 'Example:'
  opt.separator 'harvester --dir comic-con-2012 --title "Comic-Con 2012'
  opt.separator ''
  opt.separator 'Con Harvester will open comic-con-2011/person.txt and start harvesting information about each person,'
  opt.separator 'generating the comic-con-2011/README.md report in the process.'
  opt.separator ''
end

opt_parser.parse!

mandatory = [:directory, :title]
missing = mandatory.select{ |param| options[param].nil? }
if not missing.empty?
  puts "Missing options: #{missing.join(', ')}"
  puts opt_parser
  exit
end

url = 'http://api.comicvine.com/search/'.sign.accept_json.return_fields :name, :api_detail_url, :deck
url = "#{url}&resources=person&query=ron%20lim"

Utils.execute_get url

report = File.new("#{options[:directory]}/README.md", 'w:utf-8')
reporter = Reporter.new(report, options[:title])

File.open("#{options[:directory]}/people.txt", 'r:utf-8').each do |name|
  person = Person.find name.strip
  if person
    reporter.log person
  end
end
