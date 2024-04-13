# LOAD DATA LOCAL INFILE 'D:/ww/Crashes and Weather/data/data/moskva1.data'
# INTO TABLE import_data.import_crash
# FIELDS TERMINATED BY ','
# ENCLOSED BY '"'
# LINES TERMINATED BY '\n'
# IGNORE 1 ROWS;


DROP TABLE IF EXISTS incident;
CREATE TABLE incident(
    incident_id INT PRIMARY KEY,
    incident_date DATETIME,
    light TEXT,
    region TEXT,
    weather VARCHAR(20),
    road_conditions TEXT,
    severity VARCHAR(20),
    dead_count INT
                     );
DROP TABLE IF EXISTS participant;

CREATE TABLE participant(
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    incident_id INT,
    year_car INT,
    brand TEXT,
    model TEXT,
    color TEXT,
    category TEXT,
    gender VARCHAR(20),
    driving_experience INT,
    FOREIGN KEY(incident_id) REFERENCES incident(incident_id) ON DELETE CASCADE
);
DROP TABLE TEST;
CREATE TABLE TEST(
    rand INT
);

DROP TABLE IF EXISTS weather;

CREATE TABLE weather(
    w_date DATE,
    w_time TIME,
    temprature TIME,
    rain_mm INT,
    PRIMARY KEY(w_date, w_time)
);
