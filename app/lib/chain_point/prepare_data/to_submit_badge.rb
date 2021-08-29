class ChainPoint::PrepareData::ToSubmitBadge < ChainPoint::PrepareData

  def call
    badge_data = get_neccessary_params
    sha = create_sha(badge_data)

    create_hash(sha)
  end

  private

  def get_neccessary_params
    params.slice(:issue_date, :recipient_name, :uuid).to_s
  end

  def create_sha(badge_data)
    Digest::SHA2.hexdigest badge_data
  end

  def create_hash(sha)
    { 
      hashes: [sha] 
    }.to_json
  end
end
