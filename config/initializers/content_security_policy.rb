# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

# Rails.application.configure do
# config.content_security_policy do |policy|
# policy.default_src :self, :https
# policy.font_src    :self, :https, :data
# policy.img_src     :self, :https, :data
# policy.object_src  :none
# policy.script_src  :self, :https
# policy.style_src   :self, :https
# policy.frame_src   :self, :https, 'https://oauth.telegram.org/'
## policy.frame_ancestors :self, :https, 'https://oauth.telegram.org/', 'https://oauth.telegram.org/embed/vilna_dev_bot', 'http://127.0.0.1'
# policy.frame_ancestors :self, :https, 'https://oauth.telegram.org/', 'https://oauth.telegram.org/embed/vilna_dev_bot', 'http://127.0.0.1'
## Specify URI for violation reports
## policy.report_uri "/csp-violation-report-endpoint"
# end

## Generate session nonces for permitted importmap, inline scripts, and inline styles.
# config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
## config.content_security_policy_nonce_directives = %w(script-src style-src)

## Report violations without enforcing the policy.
# config.content_security_policy_report_only = false
# end
