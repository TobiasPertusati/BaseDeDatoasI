--Para modelar una base de datos en la que tienes una tabla componentes con diferentes tipos de componentes (como motherboards, procesadores, tarjetas de video, etc.), y considerando que cada tipo de componente tiene caracter�sticas individuales, te sugiero aplicar un enfoque de herencia en bases de datos relacionales, donde los componentes espec�ficos heredan de un componente general.

--Aqu� te dejo una estrategia de modelado usando una combinaci�n de herencia por relaciones y la normalizaci�n adecuada.

--1. Tablas Base
--Primero, mant�n la estructura b�sica de tu tabla componentes para almacenar los datos comunes entre todos los componentes:

CREATE TABLE componentes (
    id INT PRIMARY KEY,
    nombre VARCHAR(255),
    precio DECIMAL(10, 2),
    stock INT,
    id_marca INT,
    id_tipo_componente INT,
    FOREIGN KEY (id_marca) REFERENCES marcas(id),
    FOREIGN KEY (id_tipo_componente) REFERENCES tipos_componentes(id)
);
--2. Tabla tipos_componentes
--Esta tabla contendr� los tipos gen�ricos de componentes, como motherboards, procesadores, tarjetas de video, etc.

CREATE TABLE tipos_componentes (
    id INT PRIMARY KEY,
    nombre VARCHAR(255)
);
--Ejemplos de datos en tipos_componentes:

--1 | Motherboard
--2 | Procesador
--3 | Tarjeta de Video
--3. Tablas Espec�ficas para Caracter�sticas Individuales
--Cada tipo de componente tendr� su propia tabla con las caracter�sticas espec�ficas. Estas tablas tendr�n una relaci�n uno a uno con la tabla componentes.

--Tabla motherboards:

CREATE TABLE motherboards (
    id INT PRIMARY KEY,
    formato VARCHAR(50),
    socket VARCHAR(50),
    chipset VARCHAR(50),
    FOREIGN KEY (id) REFERENCES componentes(id)
);
--Tabla procesadores:

CREATE TABLE procesadores (
    id INT PRIMARY KEY,
    frecuencia_ghz DECIMAL(5, 2),
    nucleos INT,
    hilos INT,
    socket VARCHAR(50),
    FOREIGN KEY (id) REFERENCES componentes(id)
);
--Tabla tarjetas_video:

CREATE TABLE tarjetas_video (
    id INT PRIMARY KEY,
    memoria_gb INT,
    tipo_memoria VARCHAR(50),
    frecuencia_base_mhz INT,
    FOREIGN KEY (id) REFERENCES componentes(id)
);
--4. Relaciones y Consultas
--Cada vez que insertes un nuevo componente, lo haces en la tabla componentes, y luego insertas en la tabla espec�fica correspondiente, por ejemplo, en motherboards, procesadores, etc. usando el mismo id.

--Esto te permite:

--Mantener las caracter�sticas comunes en una sola tabla.
--Almacenar las caracter�sticas espec�ficas en tablas separadas.
--Facilitar la consulta y mantenimiento de la base de datos.
--Ejemplo de Inserci�n de Datos
--Insertar un componente gen�rico en la tabla componentes:

INSERT INTO componentes (id, nombre, precio, stock, id_marca, id_tipo_componente)
VALUES (1, 'MSI B450 Tomahawk', 120.00, 10, 1, 1);
--Insertar caracter�sticas espec�ficas de una motherboard en la tabla motherboards:

INSERT INTO motherboards (id, formato, socket, chipset)
VALUES (1, 'ATX', 'AM4', 'B450');
--Ventajas
--Flexibilidad: Puedes a�adir nuevas tablas espec�ficas para otros tipos de componentes sin alterar la estructura base.
--Escalabilidad: A medida que tu cat�logo crezca, puedes a�adir nuevas caracter�sticas sin redundancia.
--Integridad: Mantienes la integridad referencial con claves for�neas, asegurando que todos los datos est�n correctamente relacionados.
--Este enfoque te permitir� manejar componentes que comparten caracter�sticas comunes, mientras gestionas sus diferencias a trav�s de tablas especializadas.