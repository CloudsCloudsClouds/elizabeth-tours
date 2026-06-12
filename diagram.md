```mermaid
---
title: Eliz Tours — Low Level Class Diagram
---
classDiagram

    class ApplicationRecord {
        <<abstract>>
    }
    class User {
        +String email_address
        +String password_digest
        +String name
        +Integer role
        +has_secure_password
        +has_paper_trail
        +has_many sessions
        +has_many bookings
        +has_many tours (through bookings)
        +enum role: customer(0) admin(1)
        +normalizes email_address
    }
    class Session {
        +String ip_address
        +String user_agent
        +belongs_to user
    }
    class Current {
        <<ActiveSupport::CurrentAttributes>>
        +attribute :session
        +delegate :user to: session
    }
    class Tour {
        +String name
        +Text description
        +Decimal base_price
        +JSONB name_translations
        +JSONB description_translations
        +has_paper_trail
        +has_many add_ons
        +has_many bookings
        +has_many_attached images
        +validates base_price
        +translated_name()
        +translated_description()
        +name_es() / name_es=(v)
        +description_es() / description_es=(v)
    }
    class AddOn {
        +String name
        +Decimal price
        +String status
        +Boolean active
        +JSONB name_translations
        +has_paper_trail
        +belongs_to tour
        +has_many booking_add_ons
        +has_many bookings (through booking_add_ons)
        +enum status: inactive active (prefix)
        +scope active
        +validates price
        +translated_name()
        +name_es() / name_es=(v)
    }
    class Booking {
        +Text note
        +String status
        +Decimal total_price
        +DateTime tour_date
        +Integer num_guests
        +has_paper_trail
        +belongs_to user
        +belongs_to tour
        +has_many booking_add_ons
        +has_many add_ons (through booking_add_ons)
        +enum status: pending confirmed cancelled
        +validates num_guests, tour_date
        +self.create_with_add_ons(**)
    }
    class BookingAddOn {
        +Integer booking_id (PK)
        +Integer add_on_id (PK)
        +belongs_to booking
        +belongs_to add_on
    }

    class Authentication {
        <<ActiveSupport::Concern>>
        +before_action require_authentication
        +helper_method authenticated?
        +allow_unauthenticated_access(**)
        -authenticated?()
        -require_authentication()
        -resume_session()
        -find_session_by_cookie()
        -request_authentication()
        -after_authentication_url()
        -start_new_session_for(user)
        -terminate_session()
    }
    class CsvExportable {
        <<ActiveSupport::Concern>>
        +before_action handle_csv_format (only index)
        -handle_csv_format()
        -export_csv()
        -column_header(name)
    }

    class ApplicationController {
        +around_action switch_locale
        +helper_method logged_in?
        -switch_locale(&action)
        -logged_in?()
    }
    class ToursController {
        +before_action set_tour (only show)
        +index()
        +show()
    }
    class BookingsController {
        +allow_unauthenticated_access only: new
        +new()
        +create()
        -booking_params()
    }
    class SessionsController {
        +allow_unauthenticated_access only: new create
        +rate_limit 10/3min only: create
        +new()
        +create()
        +destroy()
    }
    class PasswordsController {
        +allow_unauthenticated_access
        +before_action set_user_by_token (only edit update)
        +rate_limit 10/3min only: create
        +new()
        +create()
        +edit()
        +update()
        -set_user_by_token()
    }

    class AdminApplicationController {
        +before_action require_admin
        +delegate new_session_path to main_app
        -require_admin()
        -user_for_paper_trail()
        -dashboard_from_resource(resource_name)
    }
    class AdminToursController {
        <<CsvExportable>>
    }
    class AdminBookingsController {
        <<CsvExportable>>
    }
    class AdminAddOnsController {
        <<CsvExportable>>
    }
    class AdminBookingAddOnsController {
        <<CsvExportable>>
    }
    class AdminUsersController {
        <<CsvExportable>>
    }
    class AdminVersionsController {
        +index()
        +show()
    }
    class AdminExpertSystemController {
        +index()
    }

    class TourDashboard {
        <<Administrate::BaseDashboard>>
        +ATTRIBUTE_TYPES
        +COLLECTION_ATTRIBUTES
        +SHOW_PAGE_ATTRIBUTES
        +FORM_ATTRIBUTES
        +display_resource(tour)
    }
    class BookingDashboard {
        <<Administrate::BaseDashboard>>
        +ATTRIBUTE_TYPES
        +COLLECTION_ATTRIBUTES
        +SHOW_PAGE_ATTRIBUTES
        +FORM_ATTRIBUTES
        +display_resource(booking)
    }
    class AddOnDashboard {
        <<Administrate::BaseDashboard>>
        +ATTRIBUTE_TYPES
        +COLLECTION_ATTRIBUTES
        +SHOW_PAGE_ATTRIBUTES
        +FORM_ATTRIBUTES
        +display_resource(add_on)
    }
    class BookingAddOnDashboard {
        <<Administrate::BaseDashboard>>
        +ATTRIBUTE_TYPES
        +COLLECTION_ATTRIBUTES
        +SHOW_PAGE_ATTRIBUTES
        +FORM_ATTRIBUTES
        +display_resource(booking_add_on)
    }
    class UserDashboard {
        <<Administrate::BaseDashboard>>
        +ATTRIBUTE_TYPES
        +COLLECTION_ATTRIBUTES
        +SHOW_PAGE_ATTRIBUTES
        +FORM_ATTRIBUTES
        +display_resource(user)
    }

    class ApplicationMailer {
        +default from: "from@example.com"
    }
    class PasswordsMailer {
        +reset(user)
    }

    class ApplicationJob {
        <<ActiveJob::Base>>
    }
    class ApplicationCableConnection {
        <<ActionCable::Connection::Base>>
        +identified_by current_user
        +connect()
    }

    %% ─── INHERITANCE ──────────────────────────────────────
    ApplicationRecord <|-- User
    ApplicationRecord <|-- Session
    ApplicationRecord <|-- Tour
    ApplicationRecord <|-- AddOn
    ApplicationRecord <|-- Booking
    ApplicationRecord <|-- BookingAddOn
    Current --|> ActiveSupport::CurrentAttributes : extends

    ApplicationController <|-- ToursController
    ApplicationController <|-- BookingsController
    ApplicationController <|-- SessionsController
    ApplicationController <|-- PasswordsController
    ApplicationController <|-- AdminApplicationController
    AdminApplicationController <|-- AdminToursController
    AdminApplicationController <|-- AdminBookingsController
    AdminApplicationController <|-- AdminAddOnsController
    AdminApplicationController <|-- AdminBookingAddOnsController
    AdminApplicationController <|-- AdminUsersController
    AdminApplicationController <|-- AdminVersionsController
    AdminApplicationController <|-- AdminExpertSystemController

    ApplicationMailer <|-- PasswordsMailer

    TourDashboard --|> Administrate::BaseDashboard : extends
    BookingDashboard --|> Administrate::BaseDashboard : extends
    AddOnDashboard --|> Administrate::BaseDashboard : extends
    BookingAddOnDashboard --|> Administrate::BaseDashboard : extends
    UserDashboard --|> Administrate::BaseDashboard : extends

    %% ─── CONCERN INCLUSIONS ───────────────────────────────
    BookingsController ..|> Authentication : includes
    SessionsController ..|> Authentication : includes
    PasswordsController ..|> Authentication : includes
    AdminApplicationController ..|> Authentication : includes

    AdminToursController ..|> CsvExportable : includes
    AdminBookingsController ..|> CsvExportable : includes
    AdminAddOnsController ..|> CsvExportable : includes
    AdminBookingAddOnsController ..|> CsvExportable : includes
    AdminUsersController ..|> CsvExportable : includes

    %% ─── ASSOCIATIONS ─────────────────────────────────────
    User "1" --> "*" Session : has_many
    User "1" --> "*" Booking : has_many
    Booking "*" --> "1" Tour : belongs_to
    Booking "*" --> "1" User : belongs_to
    Tour "1" --> "*" Booking : has_many
    Tour "1" --> "*" AddOn : has_many
    AddOn "*" --> "1" Tour : belongs_to
    AddOn "1" --> "*" BookingAddOn : has_many
    Booking "1" --> "*" BookingAddOn : has_many
    BookingAddOn "*" --> "1" Booking : belongs_to
    BookingAddOn "*" --> "1" AddOn : belongs_to
    Current --> Session : delegate user

    %% ─── THROUGH ASSOCIATIONS ─────────────────────────────
    User  -->  Tour : has_many through Booking
    Booking  -->  AddOn : has_many through BookingAddOn
    AddOn  -->  Booking : has_many through BookingAddOn
    Tour  -->  User : has_many through Booking
```
