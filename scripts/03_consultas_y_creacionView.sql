--Listado de ofertas laborales con modalidad “remoto” y jornada “completa”. 
--Mostrar el nombre de la empresa y los datos de la oferta, ordenados por ubicación.

 
SELECT 
    e.Nombre AS Empresa,o.Titulo,o.Ubicacion,o.Pais,m.Nombre AS Modalidad,t.Nombre AS TipoJornada
FROM Oferta o
INNER JOIN Empresa e ON o.EmpresaId = e.Id
INNER JOIN Modalidad m ON o.ModalidadId = m.Id
INNER JOIN TipoJornada t ON o.TipoJornadaId = t.Id
WHERE m.Id = 2
  AND t.Id = 1
ORDER BY o.Ubicacion;

--- Listado de usuarios que tengan experiencia laboral. 
--Mostrar nombre del usuario, email y el detalle de su experiencia, 
--ordenados por usuario y por fecha de inicio del trabajo, del más reciente al más antiguo.

SELECT 
    u.Nombre,u.Apellido,u.Email,e.Puesto,e.Empresa,e.Desde,e.Hasta
FROM Usuario u
INNER JOIN Experiencia e ON u.Id = e.UsuarioId
ORDER BY u.Nombre, u.Apellido, e.Desde DESC;

---Listado de ofertas laborales con la cantidad de usuarios postulados a cada una,
---ordenadas alfabéticamente por empresa.
---Mostrar solo las ofertas con más de una postulación.

SELECT 
    e.Nombre AS Empresa,o.Titulo AS Oferta,
    COUNT(p.UsuarioId) AS CantidadPostulaciones
FROM Oferta o
INNER JOIN Empresa e ON o.EmpresaId = e.Id
INNER JOIN Postulacion p ON o.Id = p.OfertaId
GROUP BY e.Nombre, o.Titulo
HAVING COUNT(p.UsuarioId) > 1
ORDER BY e.Nombre ASC;

---Nombre de las instituciones en que los usuarios trabajaron o estudiaron, 
---sin repetir y en una misma columna, ordenados alfabéticamente.

SELECT 
    i.Nombre AS Institucion
FROM Estudio e
INNER JOIN Institucion i ON e.InstitucionId = i.Id
UNION
SELECT ex.Empresa AS Institucion
FROM Experiencia ex
WHERE ex.Empresa IS NOT NULL
ORDER BY Institucion;

---Nombre de los usuarios que fueron descartados en al menos una oferta.

SELECT 
DISTINCT u.Nombre,u.Apellido
FROM Usuario u
INNER JOIN Postulacion p ON u.Id = p.UsuarioId
INNER JOIN EstadoPostulacion ep ON p.EstadoId = ep.Id
WHERE ep.Id = 2;   

--Crear una view en la base de datos llamada “PostulacionesView” 
--que devuelva el listado de postulaciones realizadas entre el 1° y el 15 de agosto. 
--Mostrar: nombre de la empresa, puesto de la oferta, nombre del usuario postulado, 
--fecha de postulación en formato día/mes/año, CV del usuario, y descripción del estado de la postulación.

CREATE VIEW PostulacionesView AS
SELECT 
    e.Nombre AS Empresa,
    o.Titulo AS PuestoOferta,
    u.Nombre + ' ' + u.Apellido AS Usuario,
    FORMAT (p.FechaPostulacion, 'dd-MM-yyy') AS FechaPostulacion, 
    pos.Cv,
    ep.Nombre AS EstadoPostulacion
FROM Postulacion p
INNER JOIN Usuario u ON p.UsuarioId = u.Id
INNER JOIN Postulacion pos ON  u.Id = pos.UsuarioId
INNER JOIN Oferta o ON p.OfertaId = o.Id
INNER JOIN Empresa e ON o.EmpresaId = e.Id
INNER JOIN EstadoPostulacion ep ON p.EstadoId = ep.Id
WHERE FORMAT (p.FechaPostulacion, 'dd-MM-yyy') BETWEEN '01-08-2025' AND '15-08-2025';

--Realizar una consulta sobre la view anterior y mostrar solamente la primer postulación realizada (la más antigua).

SELECT TOP 1 *
FROM PostulacionesView 
ORDER BY FechaPostulacion ASC;
