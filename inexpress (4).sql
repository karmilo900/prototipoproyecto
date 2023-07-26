-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 21-07-2023 a las 05:27:42
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `inexpress`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clasificacionprod`
--

CREATE TABLE `clasificacionprod` (
  `idclass` int(11) NOT NULL,
  `tipoprod` varchar(20) NOT NULL,
  `descripcion` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `clasificacionprod`
--

INSERT INTO `clasificacionprod` (`idclass`, `tipoprod`, `descripcion`) VALUES
(1, 'gaseosa', 'gaseosa de cola 300ml');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `factura`
--

CREATE TABLE `factura` (
  `idfactura` int(11) NOT NULL,
  `fechafactura` date NOT NULL,
  `subtotal` decimal(10,0) NOT NULL,
  `IVA` decimal(10,0) NOT NULL,
  `total` decimal(10,0) NOT NULL,
  `totalprod` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `factura_has_productos`
--

CREATE TABLE `factura_has_productos` (
  `idfactura` int(11) NOT NULL,
  `idproducto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventario`
--

CREATE TABLE `inventario` (
  `idinventario` int(11) NOT NULL,
  `fechain` datetime NOT NULL,
  `idventa` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `idproducto` int(11) NOT NULL,
  `idproductos` int(11) NOT NULL,
  `idmarca` int(11) NOT NULL,
  `idprod` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `marcaprod`
--

CREATE TABLE `marcaprod` (
  `idmarca` int(11) NOT NULL,
  `marca` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `marcaprod`
--

INSERT INTO `marcaprod` (`idmarca`, `marca`) VALUES
(1, 'cocacola');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `idprod` int(11) NOT NULL,
  `nombreprod` varchar(20) NOT NULL,
  `valorprod` decimal(10,0) NOT NULL,
  `descripcion` varchar(100) NOT NULL,
  `cantidadprod` int(11) NOT NULL,
  `idmarca` int(11) NOT NULL,
  `idclass` int(11) NOT NULL,
  `imagen` blob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`idprod`, `nombreprod`, `valorprod`, `descripcion`, `cantidadprod`, `idmarca`, `idclass`, `imagen`) VALUES
(1, 'salchipapa', 45000, 'papas pequeñas', 35, 1, 1, 0x6e6f726d616c5f636869636120666e6166342072656d6f64656c20322e706e67),
(78, 'perro', 45000, 'papas pequeñas', 123, 1, 1, 0x323032333232303234345f4652454444592046415a424541522e706e67);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `idusuario` int(11) NOT NULL,
  `nombreusuario` varchar(30) NOT NULL,
  `rolusuario` varchar(30) NOT NULL,
  `contraseña` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`idusuario`, `nombreusuario`, `rolusuario`, `contraseña`) VALUES
(1, 'Carlos', 'Empleado', '345Camilo'),
(2, 'Juanca', 'Administrador', '123456'),
(3, 'Padua', 'Administradors', '654321');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `venta`
--

CREATE TABLE `venta` (
  `idventa` int(11) NOT NULL,
  `idfactura` int(11) NOT NULL,
  `idusuario` int(11) NOT NULL,
  `idproducto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `clasificacionprod`
--
ALTER TABLE `clasificacionprod`
  ADD PRIMARY KEY (`idclass`);

--
-- Indices de la tabla `factura`
--
ALTER TABLE `factura`
  ADD PRIMARY KEY (`idfactura`),
  ADD KEY `idusuario` (`idusuario`);

--
-- Indices de la tabla `factura_has_productos`
--
ALTER TABLE `factura_has_productos`
  ADD KEY `idfactura` (`idfactura`),
  ADD KEY `idproducto` (`idproducto`);

--
-- Indices de la tabla `inventario`
--
ALTER TABLE `inventario`
  ADD PRIMARY KEY (`idinventario`),
  ADD KEY `idventa` (`idventa`),
  ADD KEY `idusuario` (`idusuario`),
  ADD KEY `idproducto` (`idproducto`),
  ADD KEY `idproductos` (`idproductos`),
  ADD KEY `idmarca` (`idmarca`),
  ADD KEY `idprod` (`idprod`);

--
-- Indices de la tabla `marcaprod`
--
ALTER TABLE `marcaprod`
  ADD PRIMARY KEY (`idmarca`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`idprod`),
  ADD KEY `idmarca` (`idmarca`),
  ADD KEY `idclass` (`idclass`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`idusuario`);

--
-- Indices de la tabla `venta`
--
ALTER TABLE `venta`
  ADD PRIMARY KEY (`idventa`),
  ADD KEY `idfactura` (`idfactura`),
  ADD KEY `idusuario` (`idusuario`),
  ADD KEY `idproducto` (`idproducto`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `factura`
--
ALTER TABLE `factura`
  ADD CONSTRAINT `factura_ibfk_1` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`),
  ADD CONSTRAINT `factura_ibfk_2` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`),
  ADD CONSTRAINT `factura_ibfk_3` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`),
  ADD CONSTRAINT `factura_ibfk_4` FOREIGN KEY (`idusuario`) REFERENCES `usuarios` (`idusuario`);

--
-- Filtros para la tabla `factura_has_productos`
--
ALTER TABLE `factura_has_productos`
  ADD CONSTRAINT `factura_has_productos_ibfk_1` FOREIGN KEY (`idfactura`) REFERENCES `factura` (`idfactura`),
  ADD CONSTRAINT `factura_has_productos_ibfk_2` FOREIGN KEY (`idproducto`) REFERENCES `productos` (`idprod`);

--
-- Filtros para la tabla `inventario`
--
ALTER TABLE `inventario`
  ADD CONSTRAINT `inventario_ibfk_1` FOREIGN KEY (`idventa`) REFERENCES `venta` (`idventa`),
  ADD CONSTRAINT `inventario_ibfk_2` FOREIGN KEY (`idusuario`) REFERENCES `venta` (`idusuario`),
  ADD CONSTRAINT `inventario_ibfk_3` FOREIGN KEY (`idproducto`) REFERENCES `venta` (`idproducto`),
  ADD CONSTRAINT `inventario_ibfk_4` FOREIGN KEY (`idproductos`) REFERENCES `productos` (`idprod`),
  ADD CONSTRAINT `inventario_ibfk_5` FOREIGN KEY (`idmarca`) REFERENCES `productos` (`idmarca`),
  ADD CONSTRAINT `inventario_ibfk_6` FOREIGN KEY (`idprod`) REFERENCES `productos` (`idprod`);

--
-- Filtros para la tabla `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `productos_ibfk_1` FOREIGN KEY (`idmarca`) REFERENCES `marcaprod` (`idmarca`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `productos_ibfk_2` FOREIGN KEY (`idclass`) REFERENCES `clasificacionprod` (`idclass`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `venta`
--
ALTER TABLE `venta`
  ADD CONSTRAINT `venta_ibfk_1` FOREIGN KEY (`idfactura`) REFERENCES `factura` (`idfactura`),
  ADD CONSTRAINT `venta_ibfk_2` FOREIGN KEY (`idusuario`) REFERENCES `factura` (`idusuario`),
  ADD CONSTRAINT `venta_ibfk_3` FOREIGN KEY (`idproducto`) REFERENCES `productos` (`idprod`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
