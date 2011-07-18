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

/**
 * Representation of a comic book issue.
 * Note that this issue is specific to a Person (as it contains information on
 * the roles the Person played in the creation of this issue).
 * @author Kevin Shekleton
 * @see http://api.comicvine.com/documentation/#issue
 */
class Issue {
    String url
    String volume
    BigDecimal number
    def roles = []

    def init() {
        url = url.sign().acceptJson().returnFields('issue_number,volume_credits')
        def json = Utils.executeGet(url)

        def issue = json.results

        String issueNumber = issue.issue_number
        if (issueNumber && issueNumber != 'null') {
            this.number = new BigDecimal(issue.issue_number).stripTrailingZeros()
        }

        this.volume = issue.volume.name
    }

    String toString() {
        def numberDisplay = number ? "#${number.toPlainString()}" : ''
        "${volume} ${numberDisplay} (${roles.join(',')})"
    }
}
