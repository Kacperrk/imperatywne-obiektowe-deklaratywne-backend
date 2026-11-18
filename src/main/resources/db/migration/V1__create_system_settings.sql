CREATE TABLE system_settings
(
    id integer PRIMARY KEY DEFAULT 1,

    loan_period_days integer NOT NULL DEFAULT 30,
    max_loan_count integer NOT NULL DEFAULT 5,
    reservation_period_days integer NOT NULL DEFAULT 3,

    borrowing_block_days_after_overdue integer NOT NULL DEFAULT 3,
    overdue_fine_per_day numeric(6, 2) NOT NULL DEFAULT 0.50,
    lost_after_overdue_days integer NOT NULL DEFAULT 60,
    default_replacement_fee numeric(8, 2) NOT NULL DEFAULT 40.00,

    reminder_days_before_due integer NOT NULL DEFAULT 3,

    CONSTRAINT system_settings_single_row_check
        CHECK (id = 1),
    CONSTRAINT system_settings_loan_period_days_check
        CHECK (loan_period_days BETWEEN 1 AND 365),
    CONSTRAINT system_settings_max_loan_count_check
        CHECK (max_loan_count BETWEEN 1 AND 50),
    CONSTRAINT system_settings_reservation_period_days_check
        CHECK (reservation_period_days BETWEEN 1 AND 30),
    CONSTRAINT system_settings_borrowing_block_days_check
        CHECK (borrowing_block_days_after_overdue BETWEEN 0 AND 30),
    CONSTRAINT system_settings_overdue_fine_per_day_check
        CHECK (overdue_fine_per_day >= 0),
    CONSTRAINT system_settings_lost_after_overdue_days_check
        CHECK (lost_after_overdue_days >= 1),
    CONSTRAINT system_settings_replacement_fee_check
        CHECK (default_replacement_fee >= 0),
    CONSTRAINT system_settings_reminder_days_check
        CHECK (reminder_days_before_due >= 0)
);

INSERT INTO system_settings DEFAULT
VALUES;
