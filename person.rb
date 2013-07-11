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

require 'json'
require 'open-uri'

# Representation of a Person and the comic issues they played a role in creating.
#
# See http://www.comicvine.com/api/documentation#toc-0-18
class Person

  # Searches for a particular person by the given name
  #
  # name- The name (cannot be null).
  #
  # Returns the non-null Person, if found; nil otherwise.
  def self.find(name)
    puts "Searching for #{name}"

    url = 'http://www.comicvine.com/api/search/'.sign.accept_json.return_fields :name, :api_detail_url, :deck
    url = "#{url}&resources=person&query=#{URI::encode(name)}"

    json = Utils.execute_get url
    return unless json

    number_of_total_results = json['number_of_total_results']
    if number_of_total_results == 0
      puts "--unable to find anyone by the name of '#{name}'"
      return
    end

    person_json = json['results'][0]

    # If there is more than one person found for the search term, try and find an exact name match
    # For instance, searching for 'David Lloyd' brings back both:
    # --David Lloyd: http://www.comicvine.com/david-lloyd/26-6118/
    # --Gareth David Lloyd: http://www.comicvine.com/gareth-david-lloyd/26-59131/
    # In this case, we have the person we're trying to find ('David Lloyd') so we assume the name with the exact match is our person
    unless number_of_total_results == 1
      person_json = json['results'].find do |result|
        name == result['name']
      end

      unless person_json
        puts "Found too many people (#{number_of_total_results}) matching '#{name}'. Please refine the query. Showing the first #{json['number_of_page_results']} people:"
        json['results'].each do |x|
          puts "--#{x['name']}: #{x['deck']}"
        end
        return
      end

      puts "There were (#{number_of_total_results}) people matching '#{name}' but an exact match was found."
    end

    new(person_json['api_detail_url'])
  end

  def initialize(url)
    url = url.sign.accept_json.return_fields :name, :issues, :deck, :site_detail_url, :image, :id
    json = Utils.execute_get url

    @name = json['results']['name']
    @site_url = json['results']['site_detail_url']
    @deck = json['results']['deck']
    @id = json['results']['id']

    if json['results']['image']
      @image_url = json['results']['image']['icon_url']
    end

    set_issues json['results']
  end

  def set_issues(json)
    @volumes = Hash.new

    json['issues'].each do |issue|
      new_issue = Issue.new(issue['api_detail_url'], @id)

      volume = @volumes[new_issue.volume_url]
      unless volume
        volume = Volume.new new_issue.volume_url
        @volumes[new_issue.volume_url] = volume
      end

      volume.add_issue new_issue, new_issue.roles
    end
  end

  def to_markdown
    volumes_display = @volumes.values.sort_by do |volume|
      volume.name
    end.collect do |volume|
      "* #{volume.to_markdown}"
    end

    img_html = @image_url ? "<img src=\"#{@image_url}\" align=\"right\" />" : ''

    <<-eos
## [#{@name}](#{@site_url}) #{img_html} ##
#{@deck}

#{volumes_display.join("\n")}
    eos
  end
end