module ApplicationHelper
    def current_controller
        params['action']
    end

    def current_action
        params['action']
    end
end
