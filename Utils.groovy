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
 * Various utilities around using the Comic Vine API.
 * @author Kevin Shekleton
 */
class Utils {
    static apiKey = null

    /**
     * Adds various useful dynamic metaClass methods.
     */
    static void addMetaMethods() {
        apiKey = new File('API-KEY').getText('UTF-8')

        /**
         * Signs the given URL with the configured API key.
         * Examples:
         *   'http://api.comicvine.com/search/'.sign()
         * @return The signed URL String.
         */
        String.metaClass.sign = {
            if (!apiKey) {
                throw new IllegalStateException('''No API key is defined.
                    You must define your Comic Vine API key in the file API-KEY.
                    If you don't have an API key, head on over to http://api.comicvine.com/ and register as a developer.''')
            }

            "${delegate}?api_key=${apiKey}"
        }

        /**
         * Adds the format filter to the URL denoting that the JSON Content-Type is desired.
         * Examples:
         *   'http://api.comicvine.com/search/'.sign().acceptJson()
         * @return The modified URL String.
         */
        String.metaClass.acceptJson = { "${delegate}&format=json" }

        /**
         * Adds the field_list filter to the URL with the given fields.
         * Examples:
         *   'http://api.comicvine.com/search/'.sign().returnFields('name')
         *   'http://api.comicvine.com/search/'.sign().returnFields('name,api_detail_url')
         * @param fields A String of comma separated fields that should be returned (cannot be null)
         * @return The modified URL String.
         */
        String.metaClass.returnFields = { fields ->
            "${delegate}&field_list=${fields}"
        }
    }

    /**
     * Executes a GET for the given Comic Vine URL.
     * @param url The URL to execute (cannot be null).
     * @return The non-null JSON response if the GET request was successfull; null otherwise.
     * @see http://api.comicvine.com/documentation/#handling_responses
     */
    static def executeGet(String url) {
        def json = url.toURL().text as JSON

        if (json.status_code != 1) {
            "Failure encountered while calling ${url}\nstatus_code: ${json.status_code}\nerror: ${json.error}"
            return null
        }

        json
    }
}