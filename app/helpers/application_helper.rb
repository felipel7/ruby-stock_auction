module ApplicationHelper
  def hide_sidebar_on_devise_pages?
    %w[sessions registrations passwords].include?(controller_name)
  end
end
