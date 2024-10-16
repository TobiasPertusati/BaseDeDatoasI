--Para modelar una base de datos en la que tienes una tabla componentes con diferentes tipos de componentes (como motherboards, procesadores, tarjetas de video, etc.), y considerando que cada tipo de componente tiene características individuales, te sugiero aplicar un enfoque de herencia en bases de datos relacionales, donde los componentes específicos heredan de un componente general.

--Aquí te dejo una estrategia de modelado usando una combinación de herencia por relaciones y la normalización adecuada.

--1. Tablas Base
--Primero, mantén la estructura básica de tu tabla componentes para almacenar los datos comunes entre todos los componentes:

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
--Esta tabla contendrá los tipos genéricos de componentes, como motherboards, procesadores, tarjetas de video, etc.

CREATE TABLE tipos_componentes (
    id INT PRIMARY KEY,
    nombre VARCHAR(255)
);
--Ejemplos de datos en tipos_componentes:

--1 | Motherboard
--2 | Procesador
--3 | Tarjeta de Video
--3. Tablas Específicas para Características Individuales
--Cada tipo de componente tendrá su propia tabla con las características específicas. Estas tablas tendrán una relación uno a uno con la tabla componentes.

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
--Cada vez que insertes un nuevo componente, lo haces en la tabla componentes, y luego insertas en la tabla específica correspondiente, por ejemplo, en motherboards, procesadores, etc. usando el mismo id.

--Esto te permite:

--Mantener las características comunes en una sola tabla.
--Almacenar las características específicas en tablas separadas.
--Facilitar la consulta y mantenimiento de la base de datos.
--Ejemplo de Inserción de Datos
--Insertar un componente genérico en la tabla componentes:

INSERT INTO componentes (id, nombre, precio, stock, id_marca, id_tipo_componente)
VALUES (1, 'MSI B450 Tomahawk', 120.00, 10, 1, 1);
--Insertar características específicas de una motherboard en la tabla motherboards:

INSERT INTO motherboards (id, formato, socket, chipset)
VALUES (1, 'ATX', 'AM4', 'B450');
--Ventajas
--Flexibilidad: Puedes añadir nuevas tablas específicas para otros tipos de componentes sin alterar la estructura base.
--Escalabilidad: A medida que tu catálogo crezca, puedes añadir nuevas características sin redundancia.
--Integridad: Mantienes la integridad referencial con claves foráneas, asegurando que todos los datos estén correctamente relacionados.
--Este enfoque te permitirá manejar componentes que comparten características comunes, mientras gestionas sus diferencias a través de tablas especializadas.