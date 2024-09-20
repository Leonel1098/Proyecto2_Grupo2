-- Estas tablas fueron creadas para realizar un sistema de gestión de reservas en restaurantes cuya plataforma 
--permite a los restaurantes organizar y administrar sus reservas de manera eficiente. Facilita la creación de 
-- reservas en línea, la visualización de la disponibilidad de mesas y la gestión de cancelaciones.


create database GestiondeReservaciones



use GestiondeReservaciones

--Esta tabla contendra la información de las diferentes surcursales

CREATE TABLE Restaurantes (
    restaurante_id INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    direccion NVARCHAR(255) NOT NULL,
    telefono NVARCHAR(15),
    email NVARCHAR(100)
);


--Tabla que contendra la lista de clientes con sus datos de contacto
CREATE TABLE Clientes (
    cliente_id INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(50) NOT NULL,
    apellido NVARCHAR(50) NOT NULL,
    telefono NVARCHAR(15),
    email NVARCHAR(100)
);

-- Tabla Reservaciones es la tabla que realizará la relación entre los clientes y la Sucursal en donde se hará la reservación
--Agregar Nueva Reserva o Rervación

CREATE TABLE Reservaciones (
    reservacion_id INT PRIMARY KEY IDENTITY(1,1),
    cliente_id INT FOREIGN KEY REFERENCES Clientes(cliente_id),
    restaurante_id INT FOREIGN KEY REFERENCES Restaurantes(restaurante_id),
    fecha_hora DATETIME NOT NULL,
    numero_personas INT NOT NULL, 
    estado NVARCHAR(20) CHECK (estado IN ('confirmada', 'cancelada', 'completada')),
    comentarios NVARCHAR(255)
);

-- Esta tabla contiene la información de las mesas por sucursal e Restauranes.

CREATE TABLE Mesas (
    mesa_id INT PRIMARY KEY IDENTITY(1,1),
    numero_mesa INT NOT NULL,
    capacidad INT NOT NULL,
    ubicacion NVARCHAR(50),
    restaurante_id INT FOREIGN KEY REFERENCES restaurantes(restaurante_id)
);

--tabla creada para validadr la disponibilidad de mesas por restaurante

CREATE TABLE Disponibilidad (	
    disponibilidad_id INT PRIMARY KEY IDENTITY(1,1),
    mesa_id INT FOREIGN KEY REFERENCES Mesas(mesa_id),
    fecha DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL
);


--Esta tabla contiene la información de los usuarios del sistema de GestiondeReservas
CREATE TABLE Usuarios (
    usuario_id INT PRIMARY KEY IDENTITY(1,1),
    nombre_usuario NVARCHAR(50) NOT NULL UNIQUE, --Asegura que los datos en la columna sean únicos, lo que ayuda a mantener la calidad e integridad de los datos.
    contrasena NVARCHAR(255) NOT NULL,
    rol NVARCHAR(20) CHECK (rol IN ('administrador', 'empleado'))
);

--En esta tabla irá guardada la información historica de las reservaciones, por favor revisala leo sino la omitimos

CREATE TABLE Historial_Reservaciones (
    historial_id INT PRIMARY KEY IDENTITY(1,1),
    reservacion_id INT FOREIGN KEY REFERENCES Reservaciones(reservacion_id),
    fecha_cambio DATETIME NOT NULL,
    estado_anterior NVARCHAR(20),
    estado_nuevo NVARCHAR(20)
);

--En esta tabla irá contenida la información correspondiente a la información proporcionada por el cliente
--en cuanto a calidad y servicio.


CREATE TABLE Comentarios_Resenas (
    comentario_id INT PRIMARY KEY IDENTITY(1,1),
    cliente_id INT FOREIGN KEY REFERENCES Clientes(cliente_id),
    reservacion_id INT FOREIGN KEY REFERENCES Reservaciones(reservacion_id),
    puntuacion INT CHECK (puntuacion BETWEEN 1 AND 5),
    comentario NVARCHAR(255),
    fecha DATETIME NOT NULL DEFAULT GETDATE()
);



CREATE OR ALTER PROCEDURE sp_CrearCliente
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @Email NVARCHAR(255),
    @Telefono NVARCHAR(15)
AS
BEGIN
    INSERT INTO Clientes (Nombre,apellido,Email,Telefono)
    VALUES (@Nombre,@Apellido, @Email, @Telefono)
END;


CREATE PROCEDURE sp_ObtenerClientes
AS
BEGIN
    SELECT * FROM Clientes
END;

CREATE PROCEDURE sp_ActualizarCliente
    @ClienteID INT,
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100),
    @Email NVARCHAR(255),
    @Telefono NVARCHAR(15)
AS
BEGIN
    UPDATE Clientes
    SET Nombre = @Nombre, apellido =  @Apellido, email = @Email, Telefono = @Telefono
    WHERE cliente_id = @ClienteID
END;


CREATE PROCEDURE sp_EliminarCliente
    @ClienteID INT
AS
BEGIN
    DELETE FROM Clientes WHERE cliente_id = @ClienteID
END;


select * from Clientes