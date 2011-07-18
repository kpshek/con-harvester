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
 * Writes a convention harvest report.
 * @author Kevin Shekleton
 */
class Reporter {
    File file

    /**
     * Constructs a Reporter.
     * @param The report file (cannot be null)
     * @param The report title (cannot be null)
     */
    Reporter(File file, String title) {
        println "Writing the Markdown report for ${title}..."

        this.file = file
        file << "# ${title} #\n"
        file << "This report was created on ${new Date().toString()}\n\n"
    }

    /**
     * Logs the given person to this report.
     * @param The person to log to this report (cannot be null).
     */
    void log(def person) {
        file << person.toString()
        file << '\n\n'
    }
}