require "test_helper"

class TourTest < ActiveSupport::TestCase
  setup do
    @tour = tours(:one)
  end

  test "translated_name falls back to name when no translation" do
    I18n.with_locale(:en) do
      assert_equal @tour.name, @tour.translated_name
    end
  end

  test "translated_name returns English when locale is en" do
    @tour.name_translations = { "en" => "English Name" }
    I18n.with_locale(:en) do
      assert_equal "English Name", @tour.translated_name
    end
  end

  test "translated_name returns Spanish when locale is es" do
    @tour.name_translations = { "es" => "Nombre español" }
    I18n.with_locale(:es) do
      assert_equal "Nombre español", @tour.translated_name
    end
  end

  test "translated_name falls back to name when locale has no translation" do
    @tour.name_translations = { "en" => "English Name" }
    I18n.with_locale(:es) do
      assert_equal @tour.name, @tour.translated_name
    end
  end

  test "translated_description falls back to description when no translation" do
    I18n.with_locale(:en) do
      assert_equal @tour.description, @tour.translated_description
    end
  end

  test "translated_description returns Spanish when set" do
    @tour.description_translations = { "es" => "Descripción española" }
    I18n.with_locale(:es) do
      assert_equal "Descripción española", @tour.translated_description
    end
  end

  test "name_es virtual attribute" do
    @tour.name_es = "Nombre español"
    assert_equal "Nombre español", @tour.name_es
    assert_equal "Nombre español", @tour.name_translations["es"]
  end

  test "name_es returns nil when not set" do
    assert_nil @tour.name_es
  end

  test "description_es virtual attribute" do
    @tour.description_es = "Descripción española"
    assert_equal "Descripción española", @tour.description_es
    assert_equal "Descripción española", @tour.description_translations["es"]
  end

  test "description_es returns nil when not set" do
    assert_nil @tour.description_es
  end

  test "name_es persists to database" do
    @tour.update!(name_es: "Tour en español")
    @tour.reload
    assert_equal "Tour en español", @tour.name_translations["es"]
  end
end
