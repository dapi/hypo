class Blockchain < ApplicationRecord
  def to_s
    name
  end

  def nodex_url
    ApplicationConfig.nodex_template_url.gsub("${BLOCKCHAIN_KEY}", key)
  end
end
