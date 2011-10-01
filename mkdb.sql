CREATE TABLE words (band INTEGER, word STRING);
CREATE INDEX words_index on words (word);
.separator ','
.import gfreqout.txt words
DELETE FROM words WHERE LENGTH(word) <= 2;
VACUUM;
.exit
