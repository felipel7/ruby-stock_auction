class Admin::ProfilesController < ApplicationController
  include AuthorizationHelper

  before_action :authenticate_user!
  before_action -> { check_admin_role(current_user) }

  def index
    @users = User.all
  end

  def block
    return unless current_user.admin?

    @user = User.find(params[:id])
    @blocked_cpf = BlockedCpf.find_by(cpf: @user.cpf)

    if @blocked_cpf
      flash[:warning] = t('profiles.blocked.warning.save')
    else
      @blocked_cpf = BlockedCpf.create!(cpf: @user.cpf)
      flash[:notice] = t('profiles.blocked.success.save')
    end

    redirect_to admin_profiles_path
  end

  def unblock
    return unless current_user.admin?

    @user = User.find(params[:id])
    @blocked_cpf = BlockedCpf.find_by(cpf: @user.cpf)

    if @blocked_cpf&.destroy
      flash[:notice] = t('profiles.unblocked.success.save')
    else
      flash[:warning] = t('profiles.unblocked.warning.save')
    end

    redirect_to admin_profiles_path
  end
end
