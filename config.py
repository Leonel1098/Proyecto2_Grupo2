import os

class Config:
    SQLALCHEMY_DATABASE_URI = 'mssql+pyodbc://Leonel:Leonel@LEONEL/GestiondeReservaciones?driver=ODBC+Driver+17+for+SQL+Server'
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SECRET_KEY = os.urandom(24)
