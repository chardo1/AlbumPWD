CREATE DATABASE IF NOT EXISTS album_fotos
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE album_fotos;

-- =========================================
-- USUARIOS
-- =========================================
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    pass VARCHAR(255) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    rol ENUM('visitante', 'usuario', 'moderador', 'admin') NOT NULL DEFAULT 'visitante',
    activo BOOLEAN NOT NULL DEFAULT TRUE
);

-- =========================================
-- ALBUMES
-- tipo: privado, publico, grupo o usuario
-- =========================================
CREATE TABLE albumes (
    id_album INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('privado', 'publico', 'grupo', 'usuario') NOT NULL,
    id_creador INT NOT NULL,
    categoria VARCHAR(100),
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    hojas INT NOT NULL DEFAULT 0,
    figuras_hoja INT NOT NULL DEFAULT 0,
    activo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_album_creador
        FOREIGN KEY (id_creador)
        REFERENCES usuarios(id_usuario)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- =========================================
-- HOJAS DE CADA ALBUM
-- =========================================
CREATE TABLE hojas (
    id_hoja INT AUTO_INCREMENT PRIMARY KEY,
    id_album INT NOT NULL,
    orden INT NOT NULL,
    titulo VARCHAR(150),
    descripcion TEXT,

    CONSTRAINT fk_hoja_album
        FOREIGN KEY (id_album)
        REFERENCES albumes(id_album)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    UNIQUE (id_album, orden)
);

-- =========================================
-- FIGURAS / FOTOS DE CADA HOJA
-- =========================================
CREATE TABLE figuras (
    id_figura INT AUTO_INCREMENT PRIMARY KEY,
    id_album INT NOT NULL,
    id_hoja INT NOT NULL,
    orden INT NOT NULL,
    titulo VARCHAR(150),
    imagen VARCHAR(255) NOT NULL,

    CONSTRAINT fk_figura_hoja
        FOREIGN KEY (id_hoja)
        REFERENCES hojas(id_hoja)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    UNIQUE (id_hoja, orden)
);

-- =========================================
-- COLABORADORES
-- Permisos de un usuario sobre un álbum.
-- =========================================
CREATE TABLE colaboradores (
    id_album INT NOT NULL,
    id_usuario INT NOT NULL,
    permiso VARCHAR(50) NOT NULL,

    PRIMARY KEY (id_album, id_usuario),

    CONSTRAINT fk_colaborador_album
        FOREIGN KEY (id_album)
        REFERENCES albumes(id_album)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_colaborador_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


