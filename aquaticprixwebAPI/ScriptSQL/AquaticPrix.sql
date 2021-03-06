USE [AquaticPrix]
GO
/****** Object:  StoredProcedure [dbo].[sp_a_contacto]    Script Date: 29/06/2021 22:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_a_contacto](@nombre varchar(100), @asunto varchar(50), @correoElectronico varchar(100), @mensaje varchar(500))as
begin
	insert into Contacto(nombre, asunto, correoElectronico, mensaje, fecha)
	values(@nombre, @asunto, @correoElectronico, @mensaje, GETDATE())
end

GO
/****** Object:  StoredProcedure [dbo].[sp_a_persona]    Script Date: 29/06/2021 22:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_a_persona](@nombre varchar(50), @apellido varchar(50), @correoElectronico varchar(100), @fechaNacimiento date)as
begin
	insert into Persona(nombre, apellido, correoElectronico, fechaNacimiento, fechaAlta)
	values(@nombre, @apellido, @correoElectronico, @fechaNacimiento, GETDATE())

	select @@IDENTITY as 'idPesona'
end

GO
/****** Object:  StoredProcedure [dbo].[sp_a_personausuario]    Script Date: 29/06/2021 22:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_a_personausuario](@idPersona int, @idUsuario int)as
begin
	insert PersonaUsuario(idPersona, idUsuario, fechaAlta) values(@idPersona, @idUsuario, GETDATE())
end

GO
/****** Object:  StoredProcedure [dbo].[sp_a_usuario]    Script Date: 29/06/2021 22:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_a_usuario](@nombreUsuario varchar(50), @clave varchar(100), @estado int)as
begin
	insert into usuario(nombreUsuario, clave, estado)
	values(@nombreUsuario, @clave, @estado)
	select @@IDENTITY as 'idUsuario'
end

GO
/****** Object:  StoredProcedure [dbo].[sp_l_estadisticas]    Script Date: 29/06/2021 22:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_l_estadisticas] as
begin
select u.idUsuario, u.nombreUsuario,e.posicion, e.perdido,e.promedioPartidas,e.bajas, e.caidas, e.promediobaja, e.promedioCaidas, e.fecha 
from usuarioEstadistica ue inner join Usuario u on ue.idusuario = u.idUsuario inner join Estadisticas e on
				ue.idestadistica = e.idEstadistica

end
GO
/****** Object:  StoredProcedure [dbo].[sp_l_usuario_persona]    Script Date: 29/06/2021 22:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_l_usuario_persona](@op int) as
begin


	if @op =1
		begin
			select per.id, per.nombre, per.apellido, per.correoElectronico, per.fechaNacimiento, usu.idUsuario, usu.nombreUsuario, usu.estado
			from Persona per inner join PersonaUsuario up on per.id = up.idPersona
				inner join Usuario usu on up.idUsuario = usu.idUsuario
			where usu.estado in(2,3)

		end
	else if @op =2
		begin
			select per.id, per.nombre, per.apellido, per.correoElectronico, per.fechaNacimiento, usu.idUsuario, usu.nombreUsuario, usu.estado
			from Persona per inner join PersonaUsuario up on per.id = up.idPersona
				inner join Usuario usu on up.idUsuario = usu.idUsuario
			where usu.estado  = 1
		end
	
end
GO
/****** Object:  StoredProcedure [dbo].[sp_l_validar_mail]    Script Date: 29/06/2021 22:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_l_validar_mail](@correoElectronico varchar(100))as
	begin
		IF EXISTS (select * from Persona where correoElectronico = @correoElectronico) 
		BEGIN
		   SELECT 'true' as 'estado'
		END
		ELSE
		BEGIN
			SELECT 'false' as 'estado'
		END
	end

GO
/****** Object:  StoredProcedure [dbo].[sp_l_validar_usuario]    Script Date: 29/06/2021 22:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_l_validar_usuario](@nombreUsuario varchar(50))as
	begin
		IF EXISTS (select * from Usuario where nombreUsuario = @nombreUsuario) 
		BEGIN
		   SELECT 'true'  as 'estado'
		END
		ELSE
		BEGIN
			SELECT 'false'  as 'estado'
		END
	end

GO
/****** Object:  StoredProcedure [dbo].[sp_l_validarLogin]    Script Date: 29/06/2021 22:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_l_validarLogin](@nombreUsuario varchar(50), @clave varchar(100))as
begin
	select per.id, per.nombre, per.apellido, per.correoElectronico, per.fechaNacimiento, usu.idUsuario, usu.estado
	from Persona per inner join PersonaUsuario up on per.id = up.idPersona
		inner join Usuario usu on up.idUsuario = usu.idUsuario
	where usu.nombreUsuario = @nombreUsuario and usu.clave = @clave
end 


GO
/****** Object:  StoredProcedure [dbo].[sp_u_usuario_clave]    Script Date: 29/06/2021 22:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_u_usuario_clave](@idUsuario int, @nombreUsuario varchar(50), @clave varchar(100), @claveNueva varchar(100))as
begin
	update Usuario set clave = @claveNueva
	where idUsuario = @idUsuario and clave = @clave
end
GO
/****** Object:  Table [dbo].[Contacto]    Script Date: 29/06/2021 22:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Contacto](
	[idContacto] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](100) NOT NULL,
	[asunto] [varchar](50) NOT NULL,
	[correoElectronico] [varchar](100) NOT NULL,
	[mensaje] [varchar](500) NOT NULL,
	[fecha] [datetime] NOT NULL,
 CONSTRAINT [PK_Contacto] PRIMARY KEY CLUSTERED 
(
	[idContacto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Estadisticas]    Script Date: 29/06/2021 22:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Estadisticas](
	[idEstadistica] [int] IDENTITY(1,1) NOT NULL,
	[posicion] [int] NOT NULL,
	[perdido] [int] NOT NULL,
	[promedioPartidas] [int] NOT NULL,
	[bajas] [int] NOT NULL,
	[caidas] [int] NOT NULL,
	[promediobaja] [int] NOT NULL,
	[promedioCaidas] [int] NOT NULL,
	[fecha] [datetime] NOT NULL,
 CONSTRAINT [PK_Estadisticas] PRIMARY KEY CLUSTERED 
(
	[idEstadistica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Persona]    Script Date: 29/06/2021 22:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Persona](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[apellido] [varchar](50) NOT NULL,
	[correoElectronico] [varchar](100) NOT NULL,
	[fechaNacimiento] [date] NOT NULL,
	[fechaAlta] [datetime] NOT NULL,
	[fechaBaja] [datetime] NULL,
 CONSTRAINT [PK_Persona] PRIMARY KEY CLUSTERED 
(
	[correoElectronico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PersonaUsuario]    Script Date: 29/06/2021 22:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersonaUsuario](
	[idUsuarioPersona] [int] IDENTITY(1,1) NOT NULL,
	[idPersona] [int] NOT NULL,
	[idUsuario] [int] NOT NULL,
	[fechaAlta] [datetime] NOT NULL,
	[fechaBaja] [datetime] NULL,
 CONSTRAINT [PK_PersonaUsuario] PRIMARY KEY CLUSTERED 
(
	[idUsuarioPersona] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Usuario]    Script Date: 29/06/2021 22:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Usuario](
	[idUsuario] [int] IDENTITY(1,1) NOT NULL,
	[nombreUsuario] [varchar](50) NOT NULL,
	[clave] [varchar](100) NOT NULL,
	[estado] [int] NOT NULL,
 CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED 
(
	[idUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[usuarioEstadistica]    Script Date: 29/06/2021 22:36:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usuarioEstadistica](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idusuario] [int] NOT NULL,
	[idestadistica] [int] NOT NULL,
	[fechaalta] [datetime] NOT NULL,
 CONSTRAINT [PK_usuarioEstadistica] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
