require 'spec_helper'

describe I18n::JustRaiseExceptionHandler do
  it "returns existing string" do
    expect {
      I18n.t('app_name')
    }.to_not raise_error
  end

  it "errors when passed non-existent key" do
    expect {
      I18n.t("app_name_foo")
    }.to raise_error(I18n::MissingTranslationData)
  end

  it "relays handling to super for non-MissingTranslation" do
    expect {
      I18n.t("labels.profile_title", foo: 'bar')
    }.to raise_error(I18n::MissingInterpolationArgument)
  end
end