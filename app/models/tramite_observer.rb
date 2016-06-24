class TramiteObserver < ActiveRecord::Observer
  def after_create(tramite, user)
    TramiteMailer.deliver_signup_notification(tramite, user)
  end

  def after_save(tramite, user)
    TramiteMailer.deliver_activation(tramite, user) if user.activated_at
  end
end
