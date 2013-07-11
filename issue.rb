# Copyright 2013 Kevin Shekleton
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
# See http://www.comicvine.com/api/documentation#toc-0-9
class Issue
  attr_reader :volume, :volume_url, :number, :roles

  def initialize(url, person_id)
    @roles = roles
    url = url.sign.accept_json.return_fields :issue_number, :person_credits, :volume
    json = Utils.execute_get url

    issue = json['results']
    issue_number = issue['issue_number']

    @volume = issue['volume']['name'].strip
    @volume_url = issue['volume']['api_detail_url']
    @number = issue_number ? issue['issue_number'].to_i : -100

    @roles = []
    issue['person_credits'].each do |person|
      if person_id == person['id']
        person['role'].split(',').each do |role|
          @roles << role.strip
        end
      end
    end
  end

  def to_s
    number_display = @number > -100 ? "##{@number}" : ''
    roles_display = @roles.empty? ? '' : "(#{@roles.join(', ')})"
    "#{@volume} #{number_display} #{roles_display}".strip
  end
end
