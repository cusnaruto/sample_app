class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def password_reset user
    @user = user
    mail to: user.email, subject: "Password reset"
  end

  def password_reset_confirmation user
    @user = user
    @login_url = login_url
    mail to: @user.email,
         subject: t("user_mailer.password_reset_confirmation.subject")
  end
end
