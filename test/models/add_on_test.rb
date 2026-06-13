require "test_helper"

class AddOnTest < ActiveSupport::TestCase
  setup do
    @add_on = add_ons(:one)
  end

  test "translated_name falls back to name when no translation" do
    I18n.with_locale(:en) do
      assert_equal @add_on.name, @add_on.translated_name
    end
  end

  test "translated_name returns Spanish when set" do
    @add_on.name_translations = { "es" => "Guía" }
    I18n.with_locale(:es) do
      assert_equal "Guía", @add_on.translated_name
    end
  end

  test "name_es virtual attribute" do
    @add_on.name_es = "Guía"
    assert_equal "Guía", @add_on.name_es
    assert_equal "Guía", @add_on.name_translations["es"]
  end

  test "name_es persists to database" do
    @add_on.update!(name_es: "Guía turística")
    @add_on.reload
    assert_equal "Guía turística", @add_on.name_translations["es"]
  end
end
