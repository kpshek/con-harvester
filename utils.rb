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
require 'net/http'
require 'uri'

# Various utilities around using the Comic Vine API.
class Utils
  @@api_key = File.open('API-KEY', 'r:utf-8').read
  if @@api_key == nil || 'REPLACE_WITH_YOUR_OWN_COMIC_VINE_API_KEY' == @@api_key
    raise <<-eos
      No API key is defined.
      You must define your Comic Vine API key in the file API-KEY.
      If you don't have an API key, head on over to http://api.comicvine.com/ and register as a developer.
    eos
  end

  def self.api_key
    @@api_key
  end

  # Executes a GET for the given Comic Vine URL.
  #
  # url - The URL to execute (cannot be nil).
  #
  # See http://api.comicvine.com/documentation/#handling_responses
  #
  # Returns the non-nil JSON response if the GET request was successfull; nil otherwise.
  def self.execute_get(url)
    response = Net::HTTP.get(URI.parse(url))
    json = JSON.parse(response)

    if json['status_code'] != 1
      raise "Failure encountered while calling #{url}\nstatus_code: #{json['status_code']}\nerror: #{json['error']}"
    end

    json
  end
end

class String
  # Signs the given URL with the configured API key.
  # Examples:
  #   'http://api.comicvine.com/search/'.sign
  #
  # Returns the signed URL String.
  def sign
    "#{self}?api_key=#{Utils.api_key}"
  end

  # Adds the format filter to the URL denoting that the JSON Content-Type is desired.
  # Examples:
  #   'http://api.comicvine.com/search/'.sign.accept_json
  #
  # Returns the modified URL String.
  def accept_json
    "#{self}&format=json"
  end

  # Adds the field_list filter to the URL with the given fields.
  # Examples:
  #   'http://api.comicvine.com/search/'.sign.return_fields :name
  #   'http://api.comicvine.com/search/'.sign.return_fields :name, :api_detail_url
  #
  # fields - A vararg list of fields that should be returned (cannot be nil)
  #
  # Returns the modified URL String.
  def return_fields(*fields)
    "#{self}&field_list=#{fields.join(',')}"
  end
end
