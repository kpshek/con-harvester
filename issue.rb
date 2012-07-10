# coding: UTF-8

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

# Representation of a comic book issue.
# Note that this issue is specific to a Person (as it contains information on
# the roles the Person played in the creation of this issue).
#
# See http://api.comicvine.com/documentation/#issue
class Issue
  attr_reader :volume, :volume_url, :number

  def initialize(url, roles)
    @roles = roles
    url = url.sign.accept_json.return_fields :issue_number, :volume_credits
    json = Utils.execute_get url

    issue = json['results']
    issue_number = issue['issue_number']

    @volume = issue['volume']['name'].strip
    @volume_url = issue['volume']['api_detail_url']
    @number = issue_number ? issue['issue_number'].to_i : -100
  end

  def to_s
    number_display = @number > -100 ? "##{@number}" : ''
    roles_display = @roles.empty? ? '' : "(#{@roles.join(', ')})"
    "#{@volume} #{number_display} #{roles_display}".strip
  end
end
