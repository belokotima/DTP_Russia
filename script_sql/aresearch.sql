-- Исследование базы данных ДТП по г. Москве


-- Общее число ДТП и автомобилей учавствовавших в ДТП
SELECT (SELECT count(*) FROM incident)    AS "Число ДТП",
       (SELECT count(*) FROM participant) AS "Число автомобилей попавших в ДТП";

-- Уровни тяжести ДТП
SELECT CASE
           WHEN GROUPING(severity) = 1 THEN 'ВСЕГО'
           ELSE severity
           END AS 'Уровни тяжести ДТП',
       CONCAT(COUNT(severity),
              '(', CAST((count(*) * 100.0 / sum(count(*)) OVER ()) * 2 AS DECIMAL), '%)')
               AS 'Количество ДТП'
FROM incident
GROUP BY severity
WITH ROLLUP
ORDER BY COUNT(severity);

-- Соотношение полов в участии ДТП
SELECT gender, CONCAT(COUNT(gender), '(', CAST(count(*) * 100 / sum(count(*)) OVER () AS DECIMAL), '%)')
FROM participant
WHERE gender IS NOT NULL
GROUP BY gender;

-- Соотношение полов в участии ДТП по годам
SELECT YEAR(incident.incident_date) AS 'Год',
#      CASE
#          WHEN GROUPING(YEAR(incident.incident_date)) THEN '2015-2024'
#          ELSE YEAR(incident.incident_date)
#          END
#          AS 'Год',
#          ПОЧЕМУ НЕ РАБОТАЕТ?!

       CASE
           WHEN GROUPING(YEAR(incident.incident_date)) THEN 'ДТП за 10 лет:'
           WHEN GROUPING(participant.gender) THEN 'Всего за год:'
           ELSE participant.gender
       END
           AS 'Пол',

       CONCAT(COUNT(gender), '(',
              CAST(count(*) * 100 / sum(count(*)) OVER (PARTITION BY YEAR(incident.incident_date)) AS DECIMAL) * 2,
              '%)')                 AS 'Число ДТП'
FROM participant
         LEFT JOIN incident
           ON participant.incident_id = incident.incident_id
WHERE participant.gender IS NOT NULL
GROUP BY YEAR(incident.incident_date), participant.gender
WITH ROLLUP
;

-- Топ машин женщин, топ машин, топ времени и дат, зависимость погоды, сравнение городов
SELECT incident_day, DTP, COUNT(rand) AS 'Rand'
FROM (SELECT DAY(incident_date) AS incident_day, COUNT(DAY(incident_date)) AS 'DTP' FROM incident GROUP BY DAY(incident_date)) as incendent_by_day
JOIN TEST
ON incident_day = TEST.rand
GROUP BY rand;


-- Самые аварийные модели машин
SELECT brand, model, COUNT(brand)
FROM participant
GROUP BY participant.brand, model
ORDER BY COUNT(participant.brand) DESC;

-- Самые небезопасные модели машин(учитывая разницу в кол-ве)
SELECT brand, model, severity, COUNT(*)
     ,(CAST(count(*) * 100 / SUM(COUNT(*)) OVER (PARTITION BY brand, model) AS DECIMAL)) AS percent
FROM participant
JOIN incident ON incident.incident_id = participant.incident_id
WHERE participant.brand IS NOT NULL AND participant.model IS NOT NULL AND incident.severity IS NOT NULL
GROUP BY participant.brand, participant.model, incident.severity
HAVING COUNT(*) > 35
ORDER BY percent DESC, COUNT(*) DESC;

-- Зависимость стажа вождения на кол-во и тяжесть ДТП
SELECT  incident.severity, participant.driving_experience, COUNT(participant.driving_experience)
FROM participant
JOIN incident ON participant.incident_id = incident.incident_id
WHERE driving_experience IS NOT NULL
GROUP BY incident.severity, driving_experience
ORDER BY driving_experience;

-- Тяжесть аварии в зависимости от погоды, марки, пола
SELECT participant.category, COUNT(category) FROM participant
GROUP BY category;

-- Виды категорий
SELECT participant.category, COUNT(category) FROM participant
GROUP BY category;

