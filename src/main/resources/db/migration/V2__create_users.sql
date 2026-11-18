CREATE SEQUENCE reader_card_number_seq;
CREATE SEQUENCE librarian_number_seq;
CREATE SEQUENCE admin_number_seq;

CREATE TABLE app_user
(
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    is_reader boolean NOT NULL DEFAULT false,
    is_librarian boolean NOT NULL DEFAULT false,
    is_admin boolean NOT NULL DEFAULT false,
    reader_card_number varchar(9) UNIQUE,
    librarian_number varchar(9) UNIQUE,
    admin_number varchar(9) UNIQUE,

    first_name varchar(100),
    last_name varchar(100),
    birth_date date,

    email varchar(254),
    email_verified boolean NOT NULL DEFAULT false,
    email_reminders_consent boolean NOT NULL DEFAULT false,

    password_hash varchar(255),
    must_change_password boolean NOT NULL DEFAULT false,
    failed_login_count integer NOT NULL DEFAULT 0,
    login_locked_until timestamptz,

    borrowing_blocked_until timestamptz,

    status varchar(20) NOT NULL DEFAULT 'ACTIVE',
    created_at timestamptz NOT NULL DEFAULT now(),
    created_by bigint REFERENCES app_user (id),

    version integer NOT NULL DEFAULT 0,

    CONSTRAINT app_user_status_check
        CHECK (status IN ('ACTIVE', 'DISABLED', 'ANONYMIZED')),
    CONSTRAINT app_user_has_role_check
        CHECK (status = 'ANONYMIZED' OR is_reader OR is_librarian OR is_admin),
    CONSTRAINT app_user_reader_has_card_check
        CHECK (NOT is_reader OR reader_card_number IS NOT NULL),
    CONSTRAINT app_user_librarian_has_number_check
        CHECK (NOT is_librarian OR librarian_number IS NOT NULL),
    CONSTRAINT app_user_admin_has_number_check
        CHECK (NOT is_admin OR admin_number IS NOT NULL),
    CONSTRAINT app_user_reader_card_number_format_check
        CHECK (reader_card_number ~ '^R-[0-9]{7}$'
) ,
    CONSTRAINT app_user_librarian_number_format_check
        CHECK (librarian_number ~ '^L-[0-9]{7}$'),
    CONSTRAINT app_user_admin_number_format_check
        CHECK (admin_number ~ '^A-[0-9]{7}$'),
    CONSTRAINT app_user_password_requires_email_check
        CHECK (password_hash IS NULL OR email IS NOT NULL),
    CONSTRAINT app_user_reminders_require_email_check
        CHECK (NOT email_reminders_consent OR email IS NOT NULL),
    CONSTRAINT app_user_personal_data_check
        CHECK (status = 'ANONYMIZED'
               OR (first_name IS NOT NULL AND last_name IS NOT NULL AND birth_date IS NOT NULL)),
    CONSTRAINT app_user_failed_login_count_check
        CHECK (failed_login_count >= 0)
);

CREATE UNIQUE INDEX app_user_email_uq ON app_user (lower(email));
