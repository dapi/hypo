module Sorcery
  module Controller
    module InstanceMethods
      def redirect_back_or_to(url, **options)
        redirect_to(session[:return_to_url] || url, **options)
        session[:return_to_url] = nil
      end
    end
  end
end
