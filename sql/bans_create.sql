-- Created by Vertabelo (http://vertabelo.com)
-- Script type: create
-- Scope: [tables, references, sequences, views, procedures]
-- Generated at Wed Oct 08 08:30:17 UTC 2014



-- tables
-- Table: bans
CREATE TABLE bans (
    id integer NOT NULL  PRIMARY KEY AUTOINCREMENT,
    description text,
    expires datetime NOT NULL
);

-- Table: lists
CREATE TABLE lists (
    id integer NOT NULL  PRIMARY KEY AUTOINCREMENT,
    bans_id integer NOT NULL,
    pattern text NOT NULL,
    FOREIGN KEY (bans_id) REFERENCES bans (id) ON DELETE CASCADE
);

-- Table: patterns
CREATE TABLE patterns (
    id integer NOT NULL  PRIMARY KEY AUTOINCREMENT,
    field text,
    pattern text,
    bans_id integer NOT NULL,
    FOREIGN KEY (bans_id) REFERENCES bans (id) ON DELETE CASCADE
);

-- Table: "refs"
CREATE TABLE "refs" (
    id integer NOT NULL  PRIMARY KEY AUTOINCREMENT,
    reference text,
    bans_id integer NOT NULL,
    FOREIGN KEY (bans_id) REFERENCES bans (id) ON DELETE CASCADE
);





-- End of file.

