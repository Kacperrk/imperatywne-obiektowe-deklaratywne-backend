CREATE TABLE reservation
(
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    reader_id bigint NOT NULL REFERENCES app_user (id),
    book_copy_id bigint NOT NULL REFERENCES book_copy (id),
    status varchar(20) NOT NULL DEFAULT 'ACTIVE',

    created_at timestamptz NOT NULL DEFAULT now(),
    expires_at timestamptz NOT NULL,

    CONSTRAINT reservation_status_check
        CHECK (status IN ('ACTIVE', 'FULFILLED', 'CANCELLED', 'EXPIRED')),
    CONSTRAINT reservation_expires_after_created_check
        CHECK (expires_at > created_at)
);

CREATE UNIQUE INDEX reservation_active_book_copy_uq ON reservation (book_copy_id) WHERE status = 'ACTIVE';

CREATE TABLE loan
(
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    reader_id bigint NOT NULL REFERENCES app_user (id),
    book_copy_id bigint NOT NULL REFERENCES book_copy (id),
    reservation_id bigint UNIQUE REFERENCES reservation (id),
    status varchar(20) NOT NULL DEFAULT 'ACTIVE',

    loaned_at timestamptz NOT NULL DEFAULT now(),
    due_at timestamptz NOT NULL,
    closed_at timestamptz,
    return_condition varchar(20),
    reminder_sent_at timestamptz,

    issued_by bigint REFERENCES app_user (id),
    closed_by bigint REFERENCES app_user (id),

    CONSTRAINT loan_status_check
        CHECK (status IN ('ACTIVE', 'RETURNED', 'LOST')),
    CONSTRAINT loan_due_after_loaned_check
        CHECK (due_at > loaned_at),
    CONSTRAINT loan_closed_at_matches_status_check
        CHECK ((status = 'ACTIVE') = (closed_at IS NULL)),
    CONSTRAINT loan_return_condition_check
        CHECK (return_condition IN ('OK', 'DAMAGED')),
    CONSTRAINT loan_return_condition_matches_status_check
        CHECK ((status = 'RETURNED') = (return_condition IS NOT NULL))
);

CREATE UNIQUE INDEX loan_active_book_copy_uq ON loan (book_copy_id) WHERE status = 'ACTIVE';

CREATE TABLE fine
(
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    loan_id bigint NOT NULL REFERENCES loan (id),
    type varchar(20) NOT NULL,
    days_overdue integer,
    amount numeric(8, 2) NOT NULL,

    status varchar(20) NOT NULL DEFAULT 'UNPAID',
    created_at timestamptz NOT NULL DEFAULT now(),
    paid_at timestamptz,
    payment_method varchar(20),
    collected_by bigint REFERENCES app_user (id),

    CONSTRAINT fine_loan_type_uq UNIQUE (loan_id, type),
    CONSTRAINT fine_type_check
        CHECK (type IN ('OVERDUE', 'DAMAGE', 'LOSS')),
    CONSTRAINT fine_status_check
        CHECK (status IN ('UNPAID', 'PAID')),
    CONSTRAINT fine_amount_check
        CHECK (amount >= 0),
    CONSTRAINT fine_overdue_requires_days_check
        CHECK (type <> 'OVERDUE' OR (days_overdue IS NOT NULL AND days_overdue > 0)),
    CONSTRAINT fine_payment_method_check
        CHECK (payment_method IN ('AT_DESK', 'STRIPE')),
    CONSTRAINT fine_paid_fields_match_status_check
        CHECK ((status = 'PAID') = (paid_at IS NOT NULL)
            AND (status = 'PAID') = (payment_method IS NOT NULL))
);
