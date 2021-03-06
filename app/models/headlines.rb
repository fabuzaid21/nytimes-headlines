class Headlines < ActiveRecord::Base
  # attr_accessible :title, :body
  @db = CouchRest.database(ENV['CLOUDANT_URL'] + '/nytimes_small')
  @@years = [2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010]
  SEARCH_VIEW = '_design/headlines/_search/headline_title'

  def self.text_search(query)
    has_results = false
    results = @@years.map do |year|
      #{ x: Time.new(year).to_i, y: @db.view(SEARCH_VIEW, :q => "year:'#{year}' AND title:#{query}", :limit => 1)['total_rows'] }
      num_headlines = @db.view(SEARCH_VIEW, :q => "year:'#{year}' AND title:#{query}", :limit => 1)['total_rows']
      has_results ||= num_headlines != 0
      [ year, num_headlines ]
    end

    unless has_results
      return []
    end

    results
  end
end
