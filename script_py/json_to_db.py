import json, pymysql.cursors

connection = pymysql.connect(host='localhost',
                             user='root',
                             password='858858',
                             database='research_DTP',
                             cursorclass=pymysql.cursors.DictCursor)

with open('/Users/bt/Downloads/Crashes and Weather/geojson_to_csv-main/geojson/moskva1.geojson', encoding='utf-8') as json_data:
    data = json.load(json_data)
data = data['features']

for incident in data:
    incident_id = incident['properties']['id']
    incident_date = incident['properties']['datetime']
    light = incident['properties']['light']
    region = incident['properties']['region']
    weather = incident['properties']['weather'][0]
    road_conditions = incident['properties']['road_conditions'][0]
    severity = incident['properties']['severity']
    dead_count = incident['properties']['dead_count']
    with connection.cursor() as cursor:
        # Create a new record
        sql_incident = "INSERT INTO `incident` " \
                       "(`incident_id`, `incident_date`, `light`, `region`," \
                       " `weather`, `road_conditions`, `severity`, `dead_count`) VALUES (%s, %s,%s, %s, %s, %s, %s, %s)"
        cursor.execute(sql_incident,
                       (incident_id, incident_date, light, region, weather, road_conditions, severity, dead_count))

    for vehicle in incident['properties']['vehicles']:
        year_car = vehicle['year']
        brand = vehicle['brand']
        model = vehicle['model']
        color = vehicle['color']
        category = vehicle['category']
        for participant in vehicle['participants']:
            if participant['role'] == 'Водитель':
                gender = participant['gender']
                years_of_driving_experience = participant['years_of_driving_experience']
                with connection.cursor() as cursor:
                    sql_vehicle = "INSERT INTO `participant` " \
                                  "(`incident_id`, `year_car`," \
                                  " `brand`, `model`, `color` , `category`," \
                                  "`gender`, `driving_experience`) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
                    cursor.execute(sql_vehicle,
                                   (incident_id, year_car, brand, model, color, category,
                                    gender, years_of_driving_experience))
            break
    connection.commit()
