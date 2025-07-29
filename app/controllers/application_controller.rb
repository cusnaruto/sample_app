class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  # Set the locale based on the URL parameter or default to I18n.default_locale
  before_action :set_locale

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = if I18n.available_locales.include?(locale)
                    locale
                  else
                    I18n.default_locale
                  end
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
