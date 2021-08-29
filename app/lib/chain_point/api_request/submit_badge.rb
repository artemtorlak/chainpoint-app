class ChainPoint::ApiRequest::SubmitBadge < ChainPoint::ApiRequest

  def call
    data = ChainPoint::PrepareData::ToSubmitBadge.call(params)

    begin 
      response = post_data(data)
    rescue StandardError => error
      log_error(params, error); return {}
    else
      log_success(params); return response.with_indifferent_access || {}
    end
  end

  private

  def post_data(data)
    HTTParty.post(ENV['CHAINPOINT_API_URL'], body: data, headers: {'Content-Type' => 'application/json'})
  end

  def log_error(params, error)
    Rails.logger.info "Badge data with params #{params} was not submitted due to error: #{error}"
  end

  def log_success(params)
    Rails.logger.info "Badge data with params #{params} was successfully submitted to url #{ENV['CHAINPOINT_API_URL']}"
  end
end
