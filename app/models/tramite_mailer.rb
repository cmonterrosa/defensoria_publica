###################################################
# Clase que se encarga de enviar notificaciones en operaciones sobre trámites
#
###################################################
class TramiteMailer < ActionMailer::Base
  
  def notification_created(user, tramite)
    setup_email(user)
    @user = user
    @tramite = Tramite.find(tramite)
    @subject    += 'Trámite ha sido iniciado!'
    @body[:url]  = "http://#{SITE_URL}/tramite/#{@tramite.id}"
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
