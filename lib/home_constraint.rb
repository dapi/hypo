# frozen_string_literal: true

class HomeConstraint
  SUBDOMAINS = [ "", "www", "vilna" ]

  def self.matches?(_request)
    subdomain = ActionDispatch::Http::URL
      .extract_subdomains(request.host, ActionDispatch::Http::URL.tld_length)
      .first
      .to_s

    SUBDOMAINS.include? subdomain
  end
end
