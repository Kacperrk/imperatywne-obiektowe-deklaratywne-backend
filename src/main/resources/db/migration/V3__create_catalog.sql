CREATE TABLE book
(
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    title varchar(500) NOT NULL,
    authors varchar(500) NOT NULL,
    isbn_13 varchar(13) UNIQUE,
    publication_year integer,
    genre varchar(30),
    description text,

    open_library_id varchar(50) UNIQUE,
    cover_path varchar(255),

    created_at timestamptz NOT NULL DEFAULT now(),
    created_by bigint REFERENCES app_user (id),
    version integer NOT NULL DEFAULT 0,

    CONSTRAINT book_isbn_13_check
        CHECK (isbn_13 ~ '^[0-9]{13}$'
) ,
    CONSTRAINT book_publication_year_check
        CHECK (publication_year BETWEEN 1000 AND 2100),
    CONSTRAINT book_genre_check
        CHECK (genre IN ('FANTASY', 'SCIENCE_FICTION', 'HORROR', 'MYSTERY', 'THRILLER',
                         'ROMANCE', 'NONFICTION', 'KIDS', 'YOUNG_ADULT', 'CLASSIC'))
);

CREATE TABLE book_copy
(
    id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    book_id bigint NOT NULL REFERENCES book (id),
    inventory_number varchar(8) NOT NULL UNIQUE,
    status varchar(20) NOT NULL DEFAULT 'AVAILABLE',

    condition_notes text,
    replacement_price numeric(8, 2),

    created_at timestamptz NOT NULL DEFAULT now(),
    version integer NOT NULL DEFAULT 0,

    CONSTRAINT book_copy_inventory_number_check
        CHECK (inventory_number ~ '^[0-9]{8}$'
) ,
    CONSTRAINT book_copy_status_check
        CHECK (status IN ('AVAILABLE', 'RESERVED', 'LOANED', 'DAMAGED', 'LOST', 'WITHDRAWN')),
    CONSTRAINT book_copy_replacement_price_check
        CHECK (replacement_price >= 0)
);
