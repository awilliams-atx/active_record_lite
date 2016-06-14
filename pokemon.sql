CREATE TABLE pokemon (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  trainer_id INTEGER,

  FOREIGN KEY (trainer_id) REFERENCES trainer(id)
);

CREATE TABLE trainers (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  gym_id INTEGER,

  FOREIGN KEY (gym_id) REFERENCES gym(id)
);

CREATE TABLE gyms (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  gyms (id, name)
VALUES
  (1, "Pewter Gym"), (2, "Cerulean Gym");

INSERT INTO
  trainers (id, fname, gym_id)
VALUES
  (1, "Brock", 1),
  (2, "Misty", 2),
  (3, "Ned", "Ruggeri", 2),
  (4, "Catless", "Human", NULL);

INSERT INTO
  pokemon (id, name, trainer_id)
VALUES
  (1, "Breakfast", 1),
  (2, "Earl", 2),
  (3, "Haskell", 3),
  (4, "Markov", 3),
  (5, "Stray Cat", NULL);
