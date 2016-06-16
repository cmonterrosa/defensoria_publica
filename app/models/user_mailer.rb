class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Su cuenta ha sido creada'
    @body[:url]  = "http://#{SITE_URL}/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://#{SITE_URL}/"
  end

   
  def reset_notification(user)
    setup_email(user)
    @subject    += 'Liga para recuperación de contraseña'
    @body[:url]  = "http://#{SITE_URL}/reset/#{user.reset_code}"
  end
  
  protected
    def setup_email(user)
      @recipients = "#{user.email}"
      @from = "Instituto de la Defensoría Pública <#{SITE_EMAIL}>"
      @sent_on  = Time.now
      @body[:user] = user
      @subject   = " "
      @content_type = "text/html"
    end
end
