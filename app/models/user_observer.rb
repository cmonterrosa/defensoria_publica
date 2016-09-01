class UserObserver < ActiveRecord::Observer
  def after_create(user)
    UserMailer.deliver_signup_notification(user) if user.email_valid? && user.email_valid? && user.email_not_required==false
  end

  def after_save(user)
    UserMailer.deliver_activation(user)  if user.recently_activated? && user.email_valid? && user.email_not_required==false
  end

  def after_reset(user)
    UserMailer.delivery_reset(user)
  end
end
