module AuthorizationHelper
  def check_admin_role(user)
    return if user&.admin?

    flash[:alert] = t('user.access_denied')
    redirect_to root_path
  end
end
