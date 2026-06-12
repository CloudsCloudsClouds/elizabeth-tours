class Tour < ApplicationRecord
  has_paper_trail
  has_many :add_ons, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many_attached :images

  validates :base_price, numericality: { greater_than_or_equal_to: 0 }

  def translated_name
    name_translations[I18n.locale.to_s].presence || name
  end

  def translated_description
    description_translations[I18n.locale.to_s].presence || description
  end

  def name_es
    name_translations["es"]
  end

  def name_es=(value)
    self.name_translations = (name_translations || {}).merge("es" => value)
  end

  def description_es
    description_translations["es"]
  end

  def description_es=(value)
    self.description_translations = (description_translations || {}).merge("es" => value)
  end
end
