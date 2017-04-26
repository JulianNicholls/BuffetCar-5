module ApplicationCable
  identified_by :current_chef

  class Connection < ActionCable::Connection::Base
    def connect
      self.current_chef = find_current_user
    end

    def disconnect

    end

    protected

    def find_current_user
      if current_chef == Chef.find cookies.signed[:chef_id]
        current_chef
      else
        reject_unathorized_connection
      end
    end
  end
end
