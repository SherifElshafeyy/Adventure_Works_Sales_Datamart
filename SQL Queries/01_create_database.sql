USE master
go

IF Db_id('DWH_Adventure_Works') IS NOT NULL
  DROP DATABASE DWH_Adventure_Works;

CREATE DATABASE DWH_Adventure_Works
go 
