class HeadlineController < ApplicationController
  def index
  end

  def query
    results = Headlines.text_search(params['query'])
    render :text => results.to_json
  end
end
