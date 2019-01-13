class ContactMailer < ApplicationMailer
  def contact_mail(image)
    @image = image
    mail to: image.user.email, subject: "投稿確認メール"
  end
end
