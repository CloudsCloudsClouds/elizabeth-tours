class AddOn < ApplicationRecord
  belongs_to :tour
  has_many :booking_add_ons, dependent: :destroy
  has_many :bookings, through: :booking_add_ons

  enum :status, { inactive: "inactive", active: "active" }, prefix: :status
  scope :active, -> { where(active: true) }

  validates :price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def translated_name
    name_translations[I18n.locale.to_s].presence || name
  end

  def name_es
    name_translations["es"]
  end

  def name_es=(value)
    self.name_translations = (name_translations || {}).merge("es" => value)
  end
end
