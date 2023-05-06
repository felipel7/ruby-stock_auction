module AuthorizationHelper
  def check_admin_role(user)
    unless user && user.is_admin?
      flash[:alert] = "Acesso negado. Você precisa ser um administrador para acessar esta página."
      redirect_to root_path
    end
  end
end
