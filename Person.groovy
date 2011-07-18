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

import net.sf.json.*

/**
 * Representation of a Person and the comic issues they played a role in creating.
 * @author Kevin Shekleton
 * @see http://api.comicvine.com/documentation/#person
 */
class Person {
    String url
    String siteUrl
    String imageUrl
    String name
    String deck
    def issues = []

    /**
     * Searches for a particular person by the given name
     * @param name The name (cannot be null).
     * @return The non-null Person, if found; null otherwise.
     */
    static Person find(String name) {
        print "Searching for ${name}..."

        String url = 'http://api.comicvine.com/search/'.sign().acceptJson().returnFields('name,api_detail_url,deck')
        url = "${url}&resources=person&query=${URLEncoder.encode(name)}"

        def json = Utils.executeGet(url)
        if (!json) {
            return
        }

        if (json.number_of_total_results == 0) {
            println "unable to find anyone by the name of '${name}'"
            return
        }

        def personJson = json.results[0]

        // If there is more than one person found for the search term, try and find an exact name match
        // For instance, searching for 'David Lloyd' brings back both:
        // --David Lloyd: http://www.comicvine.com/david-lloyd/26-6118/
        // --Gareth David Lloyd: http://www.comicvine.com/gareth-david-lloyd/26-59131/
        // In this case, we have the person we're trying to find ('David Lloyd') so we assume the name with the exact match is our person
        if (json.number_of_total_results != 1) {
            personJson = json.results.find {
                name == it.name
            }

            if (!personJson) {
                println "found too many people (${json.number_of_total_results}) matching '${name}'. Please refine the query. Showing the first ${json.number_of_page_results} people:"
                json.results.each {
                    println "--${it.name}: ${it.deck}"
                }
                return
            }

            println "there were (${json.number_of_total_results}) people matching '${name}' but an exact match was found."
        }

        def person = new Person(url:personJson.api_detail_url)
        person.init()
        person
    }

    def init() {
        println "retrieving person details..."
        url = url.sign().acceptJson().returnFields('name,issue_credits,deck,site_detail_url,image')
        def json = Utils.executeGet(url)

        this.name = json.results.name
        this.siteUrl = json.results.site_detail_url
        this.deck = json.results.deck

        if (json.results.image != 'null') {
            this.imageUrl = json.results.image.icon_url
        }

        this.issues = json.results.issue_credits.collect {
            def roles = it.roles.collect { it.role }
            def issue = new Issue(url:it.api_detail_url, roles:roles)
            issue.init()
            issue
        }
    }

    String toString() {
        def issuesDisplay = issues.sort{ a,b ->
            if (a.volume == b.volume) {
                a.number <=> b.number
            } else {
                a.volume <=> b.volume
            }
        }.collect { "* ${it.toString()}" }

        def imgHtml = imageUrl ? "<img src=\"${imageUrl}\" align=\"right\" />" : ''

        "## [${name}](${siteUrl}) ${imgHtml}##\n${deck}\n\n${issuesDisplay.join('\n')}"
    }
}