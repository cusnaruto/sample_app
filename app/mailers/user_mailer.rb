class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end

  def password_change_confirmation(user)
    @user = user
    @login_url = login_url
    mail to: user.email, subject: "Password Changed"
  end
end
