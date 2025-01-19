module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      set_current_user || reject_unauthorized_connection
    end

    private
      def set_current_user
        # Alternative:
        # cookies.encrypted['_telik_session']['user_id']
        user_id = env["rack.session"][:user_id]
        self.current_user = User.find_by(id: user_id) if user_id
      end
  end
end
