-- create a wind turbine table --

create table Wind_Turbine(
date DATE,
Wind_speed float,
Power float,
Nacelle_ambient_temperature float,
Generator_bearing_temperature float,
Gear_oil_temperature float,
Ambient_temperature float,
Rotor_Speed float,
Nacelle_temperature float,
Bearing_temperature float,
Generator_speed float,
Yaw_angle float,
Wind_direction float,
Wheel_hub_temperature float,
Gear_box_inlet_temperature float,
Failure_status varchar
)

-- Mean --
select avg(power) from wind_turbine
 select avg(Wind_speed) from wind_turbine
 select avg(Nacelle_ambient_temperature) from wind_turbine
 select avg(Generator_bearing_temperature) from wind_turbine
 select avg(Gear_oil_temperature) from wind_turbine
 select avg(Ambient_temperature) from wind_turbine
 select avg(Rotor_Speed) from wind_turbine
 
 

-- Medain --
select Wind_speed from wind_turbine order by Wind_speed offset(select count(*)from wind_turbine)/2 limit 1

-- Mode --
select mode() within group(order by power) from wind_turbine

-- Missing values --
select power from wind_turbine where power is null

--Imputation

UPDATE wind_turbine
SET Gear_box_inlet_temperature=15.88
WHERE Gear_box_inlet_temperature IS null

-- Duplicates --
select power,count(*) from wind_turbine group by power having count(*)>1

--Maximum vaue--
select MAX(power) from wind_turbine

--Minimum value--
select MIN(power) from wind_turbine

-- Variance --
select VARIANCE(Wind_speed) from wind_turbine

-- Standard deviation-- 
select STDDEV(wind_turbine) from wind_turbine

--Skewness--

WITH SkewCTE AS
(
SELECT SUM(power) AS rx,
 SUM(POWER(power,2)) AS rx2,
 SUM(POWER(power,3)) AS rx3,
 COUNT(power) AS rn,
 STDEV(power) AS stdv,
 AVG(power) AS av
FROM wind_turbine
)
SELECT
   (rx3 - 3*rx2*av + 3*rx*av*av - rn*av*av*av)
   / (stdv*stdv*stdv) * rn / (rn-1) / (rn-2) AS Skewness
FROM SkewCTE;

--Kurtosis--
WITH KurtCTE AS
(
SELECT SUM(power) AS rx,
 SUM(POWER(power,2)) AS rx2,
 SUM(POWER(power,3)) AS rx3,
 SUM(POWER(power,4)) AS rx4,
 COUNT(power) AS rn,
 STDDEV(power) AS stdv,
 AVG(power) AS av                                                           
FROM wind_turbine
)
SELECT
   (rx4 - 4*rx3*av + 6*rx2*av*av - 4*rx*av*av*av + rn*av*av*av*av)
   / (stdv*stdv*stdv*stdv) * rn * (rn+1) / (rn-1) / (rn-2) / (rn-3)
   - 3.0 * (rn-1) * (rn-1) / (rn-2) / (rn-3) AS Kurtosis
FROM KurtCTE;

-- Outlier treatment --

Create TABLE z_score  AS
SELECT wind_speed,Power,
Nacelle_ambient_temp,
Generator_bearing_temp,
Gear_oil_temp,
Ambient_temp,
Rotor_speed,
Nacelle_temp,
Bearing_temperature,
Generator_speed,
Yaw_angle,
Wind_direction,
Wheel_hub_temperature,
Gear_box_inlet_temperature,
(wind_speed - AVG(wind_speed) OVER()) / NULLIF(STDDEV_POP(wind_speed) OVER(), 0) AS z_score_wind_speed,
(Power - AVG(Power) OVER()) / NULLIF(STDDEV_POP(Power) OVER(), 0) AS z_score_Power,
(Nacelle_ambient_temp - AVG(Nacelle_ambient_temp) OVER()) / NULLIF(STDDEV_POP(Nacelle_ambient_temp) OVER(), 0) AS z_score_Nacelle_ambient_temp,
(Generator_bearing_temp - AVG(Generator_bearing_temp) OVER()) / NULLIF(STDDEV_POP(Generator_bearing_temp) OVER(), 0) AS z_score_Generator_bearing_temp,
(Gear_oil_temp - AVG(Gear_oil_temp) OVER()) / NULLIF(STDDEV_POP(Gear_oil_temp) OVER(), 0) AS z_score_Gear_oil_temp,
(Ambient_temp - AVG(Ambient_temp) OVER()) / NULLIF(STDDEV_POP(Ambient_temp) OVER(), 0) AS z_score_Ambient_temp,
(Rotor_speed - AVG(Rotor_speed) OVER()) / NULLIF(STDDEV_POP(Rotor_speed) OVER(), 0) AS z_score_Rotor_speed,
(Nacelle_temp - AVG(Nacelle_temp) OVER()) / NULLIF(STDDEV_POP(Nacelle_temp) OVER(), 0) AS z_score_Nacelle_temp,
(Bearing_temperature - AVG(Bearing_temperature) OVER()) / NULLIF(STDDEV_POP(Bearing_temperature) OVER(), 0) AS z_score_Bearing_temperature,
(Generator_speed - AVG(Generator_speed) OVER()) / NULLIF(STDDEV_POP(Generator_speed) OVER(), 0) AS z_score_Generator_speed,
(Yaw_angle - AVG(Yaw_angle) OVER()) / NULLIF(STDDEV_POP(Yaw_angle) OVER(), 0) AS z_score_Yaw_angle,
(Wind_direction - AVG(Wind_direction) OVER()) / NULLIF(STDDEV_POP(Wind_direction) OVER(), 0) AS z_score_Wind_direction,
(Wheel_hub_temperature - AVG(Wheel_hub_temperature) OVER()) / NULLIF(STDDEV_POP(Wheel_hub_temperature) OVER(), 0) AS z_score_Wheel_hub_temperature,
(Gear_box_inlet_temperature - AVG(Gear_box_inlet_temperature) OVER()) / NULLIF(STDDEV_POP(Gear_box_inlet_temperature) OVER(), 0) AS z_score_Gear_box_inlet_temperature

FROM wind_turbine;




CREATE TABLE percentile_table AS
SELECT PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY Wind_speed) AS wind_speed_value,
 PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY Power) AS Power_value,
 PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY Nacelle_ambient_temp) AS Nacelle_ambient_temp_value,
 PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY Generator_bearing_temp) AS Generator_bearing_temp_value,
 PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY Gear_oil_temp) AS Gear_oil_temp_value,
 PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY Ambient_temp) AS Ambient_temp_value,
 PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY Rotor_speed) AS Rotor_speed_value,
 PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY Nacelle_temp) AS Nacelle_temp_value,
 PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY Bearing_temperature) AS Bearing_temperature_value,
 PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY Generator_speed) AS Generator_speed_value,
 PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY Yaw_angle) AS Yaw_angle_value,
 PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY Wind_direction) AS Wind_direction_value,
 PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY Wheel_hub_temperature) AS Wheel_hub_temperature_value,
 PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY Gear_box_inlet_temperature) AS Gear_box_inlet_temperature_value
FROM wind_turbine;


UPDATE z_score
SET wind_speed = (SELECT wind_speed_value FROM percentile_table)
WHERE z_score_wind_speed > 2.576 OR z_score_wind_speed < -2.576;

UPDATE z_score
SET Power = (SELECT Power_value FROM percentile_table)
WHERE z_score_Power > 2.576 OR z_score_Power < -2.576;

UPDATE z_score
SET Nacelle_ambient_temperature = (SELECT Nacelle_ambient_temp_value FROM percentile_table)
WHERE z_score_wind_speed > 2.576 OR z_score_wind_speed < -2.576;

UPDATE z_score
SET Generator_bearing_temperature = (SELECT Generator_bearing_temp_value FROM percentile_table)
WHERE z_score_wind_speed > 2.576 OR z_score_wind_speed < -2.576;

UPDATE z_score
SET Gear_oil_temperature = (SELECT Gear_oil_temp_value FROM percentile_table)
WHERE z_score_wind_speed > 2.576 OR z_score_wind_speed < -2.576;

UPDATE z_score
SET Ambient_temperature = (SELECT Ambient_temp_value FROM percentile_table)
WHERE z_score_wind_speed > 2.576 OR z_score_wind_speed < -2.576;

UPDATE z_score
SET Rotor_Speed = (SELECT Rotor_Speed_value FROM percentile_table)
WHERE z_score_wind_speed > 2.576 OR z_score_wind_speed < -2.576;

UPDATE z_score
SET Nacelle_temperature = (SELECT Nacelle_temp_value FROM percentile_table)
WHERE z_score_wind_speed > 2.576 OR z_score_wind_speed < -2.576;

UPDATE z_score
SET Bearing_temperature = (SELECT Bearing_temperature_value FROM percentile_table)
WHERE z_score_wind_speed > 2.576 OR z_score_wind_speed < -2.576;

UPDATE z_score
SET Generator_speed = (SELECT Generator_speed_value FROM percentile_table)
WHERE z_score_wind_speed > 2.576 OR z_score_wind_speed < -2.576;

UPDATE z_score
SET Yaw_angle = (SELECT Yaw_angle_value FROM percentile_table)
WHERE z_score_wind_speed > 2.576 OR z_score_wind_speed < -2.576;

UPDATE z_score
SET Wind_direction = (SELECT Wind_direction_value FROM percentile_table)
WHERE z_score_wind_speed > 2.576 OR z_score_wind_speed < -2.576;

UPDATE z_score
SET Wheel_hub_temperature = (SELECT Wheel_hub_temperature_value FROM percentile_table)
WHERE z_score_wind_speed > 2.576 OR z_score_wind_speed < -2.576;

UPDATE z_score
SET Gear_box_inlet_temperature = (SELECT Gear_box_inlet_temperature_value FROM percentile_table)
WHERE z_score_wind_speed > 2.576 OR z_score_wind_speed < -2.576;
