module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :current_user
  end

  def login(user)
    reset_session
    active_session = create_active_session!(user)
    session[:current_active_session_id] = active_session.id
  end

  def logout
    active_session = get_active_session
    reset_session
    active_session.destroy! if active_session.present?
  end

  def authenticate_user!
    return unless user_signed_in?
  end

  private

  def create_active_session!(user)
    user.active_sessions.each(&:destroy)
    user.active_sessions.create!(user_agent: request.user_agent, ip_address: request.ip)
  end

  def get_active_session
    ActiveSession.find_by(id: session[:current_active_session_id])
  end

  def current_user
    Current.user ||= begin
      account = get_active_session.try(:account)
      return account if account.is_a?(User)

      nil
    end
  end

  def user_signed_in?
    Current.user.present?
  end
end
