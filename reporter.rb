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

# Writes a convention harvest report.
class Reporter
  # Constructs a Reporter.
  #
  # file - The report file (cannot be nil)
  # title - The report title (cannot be nil)
  def initialize(file, title)
    puts "Writing the Markdown report for #{title}..."

    @file = file
    @file << "# #{title} #\n"
    @file << "This report was created on #{Time.new}\n\n"
  end

  # Logs the given person to this report.
  #
  # person - The person to log to this report (cannot be nil).
  def log(person)
    @file << person.to_markdown
    @file << "\n\n"
  end
end
