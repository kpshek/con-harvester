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

require 'set'

# Representation of a comic book volume.
# Note that this volume is specific to a Person (as it contains information on
# the roles the Person played and the issues they were involved in creating).
#
# For example, 'X-Men (1963)' and 'X-Men (1991)' are both volumes.
#
# See http://www.comicvine.com/api/documentation#toc-0-8
class Volume
  attr_reader :name, :issues, :roles

  def initialize(url)
    url = url.sign.accept_json.return_fields :name, :start_year, :site_detail_url
    json = Utils.execute_get url

    volume = json['results']
    start_year = volume['start_year'] ? "(#{volume['start_year']})" : ''

    @name = "#{volume['name'].strip} #{start_year}"
    @url = volume['site_detail_url']
    @issues = SortedSet.new
    @roles = SortedSet.new
  end

  def add_issue(issue, roles)
    @issues << issue.number unless issue.number < -1
    @roles.merge roles
  end

  def issue_range
    last_issue = 0
    start_sequence = 0
    first = true
    display = ''

    @issues.each do |issue|
      if (first || last_issue+1 != issue)
        unless first || start_sequence == last_issue
          display << "-#{last_issue}"
        end

        display << ', ' unless first
        display << "#{issue}"
        start_sequence = issue
      end
      last_issue = issue
      first = false
    end

    display
  end

  def to_markdown
    roles_display = @roles.empty? ? '' : "(#{@roles.to_a.join(', ')})"
    "[#{@name}](#{@url}) #{issue_range} #{roles_display}".strip
  end
end