USE PlataformaEducativa;

-- =======================
-- TABLA: Usuarios
-- =======================
IF OBJECT_ID('dbo.Usuarios','U') IS NOT NULL DROP TABLE dbo.Usuarios;
CREATE TABLE dbo.Usuarios (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    [Password] NVARCHAR(100) NOT NULL,
    Rol NVARCHAR(50) NOT NULL, -- Estudiante, Docente, Padre, Admin
    FechaRegistro DATETIME NOT NULL CONSTRAINT DF_Usuarios_FechaRegistro DEFAULT(GETDATE()),
    CONSTRAINT UQ_Usuarios_Email UNIQUE (Email),
    CONSTRAINT CK_Usuarios_Rol CHECK (Rol IN (N'Estudiante', N'Docente', N'Padre', N'Admin'))
);
CREATE INDEX IX_Usuarios_Rol ON dbo.Usuarios(Rol);

-- =======================
-- TABLA: Materias
-- =======================
IF OBJECT_ID('dbo.Materias','U') IS NOT NULL DROP TABLE dbo.Materias;
CREATE TABLE dbo.Materias (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(200) NULL,
    DocenteId INT NOT NULL,
    CONSTRAINT FK_Materias_Docente FOREIGN KEY (DocenteId) REFERENCES dbo.Usuarios(Id)
);
CREATE INDEX IX_Materias_DocenteId ON dbo.Materias(DocenteId);

-- =======================
-- TABLA: Inscripciones
-- =======================
IF OBJECT_ID('dbo.Inscripciones','U') IS NOT NULL DROP TABLE dbo.Inscripciones;
CREATE TABLE dbo.Inscripciones (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    EstudianteId INT NOT NULL,
    MateriaId INT NOT NULL,
    FechaInscripcion DATETIME NOT NULL CONSTRAINT DF_Ins_FIns DEFAULT(GETDATE()),
    CONSTRAINT FK_Ins_Estudiante FOREIGN KEY (EstudianteId) REFERENCES dbo.Usuarios(Id),
    CONSTRAINT FK_Ins_Materia FOREIGN KEY (MateriaId) REFERENCES dbo.Materias(Id),
    CONSTRAINT UQ_Ins_Estudiante_Materia UNIQUE (EstudianteId, MateriaId)
);
CREATE INDEX IX_Inscripciones_Estudiante ON dbo.Inscripciones(EstudianteId);
CREATE INDEX IX_Inscripciones_Materia ON dbo.Inscripciones(MateriaId);

-- =======================
-- TABLA: Contenidos
-- =======================
IF OBJECT_ID('dbo.Contenidos','U') IS NOT NULL DROP TABLE dbo.Contenidos;
CREATE TABLE dbo.Contenidos (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    MateriaId INT NOT NULL,
    Titulo NVARCHAR(100) NOT NULL,
    Tipo NVARCHAR(50) NOT NULL, -- PDF, Video, Link, Imagen, etc.
    Recurso NVARCHAR(200) NOT NULL, -- URL o ruta
    FechaPublicacion DATETIME NOT NULL CONSTRAINT DF_Contenidos_Fecha DEFAULT(GETDATE()),
    CONSTRAINT FK_Contenidos_Materia FOREIGN KEY (MateriaId) REFERENCES dbo.Materias(Id),
    CONSTRAINT CK_Contenidos_Tipo CHECK (Tipo IN (N'PDF',N'Video',N'Link',N'Imagen',N'Otro'))
);
CREATE INDEX IX_Contenidos_MateriaId ON dbo.Contenidos(MateriaId);

-- =======================
-- TABLA: Evaluaciones
-- =======================
IF OBJECT_ID('dbo.Evaluaciones','U') IS NOT NULL DROP TABLE dbo.Evaluaciones;
CREATE TABLE dbo.Evaluaciones (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    MateriaId INT NOT NULL,
    Titulo NVARCHAR(100) NOT NULL,
    FechaInicio DATETIME NULL,
    FechaFin DATETIME NULL,
    CONSTRAINT FK_Eval_Materia FOREIGN KEY (MateriaId) REFERENCES dbo.Materias(Id),
    CONSTRAINT CK_Eval_Fechas CHECK (FechaInicio IS NULL OR FechaFin IS NULL OR FechaFin >= FechaInicio)
);
CREATE INDEX IX_Eval_MateriaId ON dbo.Evaluaciones(MateriaId);

-- =======================
-- TABLA: Preguntas
-- =======================
IF OBJECT_ID('dbo.Preguntas','U') IS NOT NULL DROP TABLE dbo.Preguntas;
CREATE TABLE dbo.Preguntas (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    EvaluacionId INT NOT NULL,
    Enunciado NVARCHAR(300) NOT NULL,
    OpcionA NVARCHAR(200) NOT NULL,
    OpcionB NVARCHAR(200) NOT NULL,
    OpcionC NVARCHAR(200) NOT NULL,
    OpcionD NVARCHAR(200) NOT NULL,
    RespuestaCorrecta NVARCHAR(1) NOT NULL,
    CONSTRAINT FK_Preg_Eval FOREIGN KEY (EvaluacionId) REFERENCES dbo.Evaluaciones(Id),
    CONSTRAINT CK_Preg_Resp CHECK (RespuestaCorrecta IN (N'A',N'B',N'C',N'D'))
);
CREATE INDEX IX_Preguntas_EvaluacionId ON dbo.Preguntas(EvaluacionId);

-- =======================
-- TABLA: Resultados
-- =======================
IF OBJECT_ID('dbo.Resultados','U') IS NOT NULL DROP TABLE dbo.Resultados;
CREATE TABLE dbo.Resultados (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    EvaluacionId INT NOT NULL,
    EstudianteId INT NOT NULL,
    Calificacion DECIMAL(5,2) NOT NULL,
    Fecha DATETIME NOT NULL CONSTRAINT DF_Res_Fecha DEFAULT(GETDATE()),
    CONSTRAINT FK_Res_Eval FOREIGN KEY (EvaluacionId) REFERENCES dbo.Evaluaciones(Id),
    CONSTRAINT FK_Res_Estud FOREIGN KEY (EstudianteId) REFERENCES dbo.Usuarios(Id),
    CONSTRAINT UQ_Res_Eval_Estud UNIQUE (EvaluacionId, EstudianteId),
    CONSTRAINT CK_Res_Rango CHECK (Calificacion >= 0 AND Calificacion <= 20)
);
CREATE INDEX IX_Resultados_Estudiante ON dbo.Resultados(EstudianteId);
CREATE INDEX IX_Resultados_Evaluacion ON dbo.Resultados(EvaluacionId);

-- =======================
-- TABLA: Mensajes
-- =======================
IF OBJECT_ID('dbo.Mensajes','U') IS NOT NULL DROP TABLE dbo.Mensajes;
CREATE TABLE dbo.Mensajes (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    EmisorId INT NOT NULL,
    ReceptorId INT NOT NULL,
    Asunto NVARCHAR(100) NULL,
    Cuerpo NVARCHAR(MAX) NULL,
    Fecha DATETIME NOT NULL CONSTRAINT DF_Mensajes_Fecha DEFAULT(GETDATE()),
    Leido BIT NOT NULL CONSTRAINT DF_Mensajes_Leido DEFAULT(0),
    CONSTRAINT FK_Mens_Emisor FOREIGN KEY (EmisorId) REFERENCES dbo.Usuarios(Id),
    CONSTRAINT FK_Mens_Receptor FOREIGN KEY (ReceptorId) REFERENCES dbo.Usuarios(Id)
);
CREATE INDEX IX_Mensajes_Emisor ON dbo.Mensajes(EmisorId);
CREATE INDEX IX_Mensajes_Receptor ON dbo.Mensajes(ReceptorId);
