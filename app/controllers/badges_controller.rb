class BadgesController < ApplicationController

  def new; end

  def submit_to_chainpoint
    result = ChainPoint::ApiRequest::SubmitBadge.call(params)

    if result.has_key? :hashes
      redirect_to action: :success, badge_hashes: result[:hashes]
    else
      redirect_to action: :error
    end
  end

  def success; end

  def error; end
end
