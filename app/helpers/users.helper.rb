module UsersHelper
  def gender_options
    [
      [t("users.new.genders.male"), :male],
      [t("users.new.genders.female"), :female],
      [t("users.new.genders.other"), :other]
    ]
  end
end
