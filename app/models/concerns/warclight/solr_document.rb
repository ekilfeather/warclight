# frozen_string_literal: true

module Warclight
  ##
  # Extends Blacklight::Solr::Document to provide Warclight specific behavior
  module SolrDocument
    extend Blacklight::Solr::Document

    def replay_link
      time_travel_base_url = 'http://webarchiveportal.nli.ie:8080/all/timemap/json'
      time_travel_request_url = time_travel_base_url + first(:wayback_date).to_s + '/' + first(:url).to_s
      time_travel_request = URI(time_travel_request_url)
      time_travel_response = Net::HTTP.get(time_travel_request)
      if time_travel_response.present?
        time_travel_response_json = JSON.parse(time_travel_response)
        replay_url = time_travel_response_json['url']
        replay_date = time_travel_response_json['timestamp']
        replay_url_link = '<a href="' + "http://webarchiveportal:8080/all/#{replay_date}/#{replay_url}/" '" target="_blank">'"#{replay_url}"'</a> 🔗'
        replay_url_link.html_safe
      else
        replay_url = 'Not Available.'
      end
    end
  end
end
