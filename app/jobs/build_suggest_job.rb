require 'net/http'

# Rebuild the Solr suggester index
# https://lucene.apache.org/solr/guide/8_0/suggester.html
class BuildSuggestJob

  def self.build_suggest_field
    # Not using Blacklight.default_index.connection for greater control
    uri = URI("#{ENV['SOLR_URL']}/suggest")

    ::Net::HTTP.start(uri.host, uri.port) do |http|
      http.read_timeout = 600
      params = "?suggest.build=true"
      full_path = uri.path + params
      puts "Building suggester field with #{uri}#{params}"
      res = http.request_get(full_path, 'Accept' => 'application/json')
      res.value # raises exception if not 2XX status
      puts res.body
    end
  end
end
