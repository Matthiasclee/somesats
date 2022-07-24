class GiftCard < ApplicationRecord
  def expired?
    (created_at.to_i + valid_for.to_i) < DateTime.now.to_i
  end
end
