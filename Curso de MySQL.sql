# Universidade de Dados
# 1° exercicio - Tabela cliente

create table cliente(
Nome varchar(30),
Sexo char(1),
Email varchar(30),
CPF int(11),
Telefone varchar(30),
Endereco varchar(100)
);

#Comando insert 
# 1° Forma - inserindo dados sem informa as colunas
insert into cliente values (
'João',
'M',
'João@gmail.com',
988638273,
'22923110',
'Maia Lacerda - Estacio - Rio de Janeiro - RJ'
);

insert into cliente values (
'Celia',
'F',
'Celia@gmail.com',
541521456,
'250278869',
'Riachuelo - Centro - Rio de Janeiro - RJ'
);

insert into cliente values(
'Jorge',
'M',
Null,
885755896,
'58748895',
'Oscar Cury - Bom Retiro - Minas Gerais - MG'
);

# 2° forma - informando as colunas que sera inserido as informações
INSERT INTO `udemysql`.`cliente`
(`Nome`,
`Sexo`,
`CPF`,
`Telefone`,
`Endereco`)
VALUES
('Lilian',
'F',
'944785696',
8877485693,
'Senador Soares - Tijuca - Rio de Janeiro - RJ');

#3° forma - compacta (exclusivo do MySQL)
insert into cliente values(
'Ana',
'F',
'ana@globo.com',
855489652,
'548556985',
'Pres Antonio Carlos - Centron - São Paulo - SP'
),
(
'Carla',
'F',
'Carla@terati.com',
774582058,
'66587458',
'Samuel Silva - Centro - Belo Horizonte - MG'
);
select * from cliente;

# Exemplos do Comando Select
# Select now: Usado para mostrar data e horas atuais
Select now();

# Select nome(s) da(s) coluna(s) from nome da tabela;
# Comando ira exibir as colunas da tabela
select nome, sexo, email from cliente; 

# Where: usado para filtrar dados, o where é usado para casos de equidade total
 select nome, email from cliente
 where sexo = 'm';
 
 # Like: usado para filtrar dados, diferente do where este é usado para buscar
 # resultados semelhantes ao informado junto com a sintax ou seja equidade parcial.
 # o Like é  usado em conjunto com o caracter '%' que significa tudo antes ou depois,
 # no exemplo abaixo o resultado será tudo que termine com RJ
 select nome, sexo, endereco from cliente
 where endereco like '%rj';
 
 # no proximo exemplo ele ira buscar qualquer registro em que tenha a palavra 
 # centro em qualquer momento do registro
 select nome, sexo, endereco from cliente
 where endereco like '%centro%'; 
 
 # Operadores Logico
 # 'And' = irá trazer o resultado somente se todas as condições forem verdadeiras 
 select nome, email from cliente 
 where sexo = 'M' and endereco like'%rj';
 
select nome, email from cliente 
 where sexo = 'F' and endereco like'%estacio';
 
 # 'Or' = irá trazer o resultado caso uma das condições for verdade
 select nome, email from cliente 
 where sexo = 'M' or endereco like '%rj';
 
 select nome, email from cliente
 where sexo = 'F' or endereco like '%estacio';
 
  # Count: comando para contar a quantidade de registros de uma tabela
 select count(*) from cliente;
 select count(*) as "quantidade" from cliente;
 
 # Group by: pega um resultado de count e agrupa pela a coluna informada
 select sexo, count(*)as "quantidade" 
 from cliente
 group by sexo;
 
 # Update: comando usado para atualizar as informações de uma tabela.
 # o comando update sempre deve ser usado em conjunto com  o comando 
 # where para não ocorrer erros na tabela no momento do uso dele.
 update  cliente
 set email = 'lilian@hotmail.com'
 where nome = 'Lilian';
 
 #  Delete: comando usado para deletar registros de uma tabela 
 # a forma de usa-lo é igual ao 'update', sempre em conjunto com o 
 # comando where para evitar os mesmos tipos de erro
 delete from cliente
 where nome = 'Ana';
 
 # Criação de um novo banco de dados para exercicios do Udemy
 CREATE SCHEMA `comercio_udemy` ;
 use comercio_udemy;
 
 # A criação das tabelos foram feitas através da interface o workebench 
 # no momento ignorar o 'INDEX' ele será visto posteriormente com a descrição 
 # do que ele faz
 
 # Comandos utilizados:
 # Primary Key: É a chave primaria da tabela criando a coluna identificadora de 
 # cada registro.
 # Not Null: Irá fazer que a coluna não aceito valor nulo. Obrigando a inserção de 
 # informação na coluna em que foi instaciado
 # Unique: Não vai permitir que a coluna tenha registros iguais. Logo cada linha informação
 # nessa coluna será único 
 
 CREATE TABLE `comercio_udemy`.`cliente` (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(30) NOT NULL,
  `Sexo` ENUM('M', 'F') NOT NULL,
  `Email` VARCHAR(50) NULL,
  `CPF` VARCHAR(15) NULL,
  PRIMARY KEY (`idCliente`),
  UNIQUE INDEX `Email_UNIQUE` (`Email` ASC),
  UNIQUE INDEX `CPF_UNIQUE` (`CPF` ASC));
  
 CREATE TABLE `comercio_udemy`.`telefone` (
  `idtelefon` INT NOT NULL AUTO_INCREMENT,
  `Tipo` ENUM('Com', 'Res', 'Cel') NULL,
  `Telefone` VARCHAR(10) NULL,
  PRIMARY KEY (`idtelefon`));

 CREATE TABLE `comercio_udemy`.`endereco` (
  `idendereco` INT NOT NULL AUTO_INCREMENT,
  `rua` VARCHAR(30) NOT NULL,
  `bairro` VARCHAR(30) NOT NULL,
  `cidade` VARCHAR(30) NOT NULL,
  `estado` CHAR(2) NOT NULL,
  PRIMARY KEY (`idendereco`));

# Adicionando a Foreign Key ( Chave estrangeira )
# É a chave de primaria de outra tabela fazendo o relacionamento entre duas ou mais tabelas
# Como utilizar: No relacionamento 1 x 1 a chave estrangeira vai para a tabela mais fraca
# No relacionamento 1 x N a chave estrangeira vai para a tabela N.
# Dados inseridos usando a interface grafica 

 CREATE TABLE `comercio_udemy`.`endereco` (
   `idendereco` INT NOT NULL AUTO_INCREMENT,
   `rua` VARCHAR(30) NOT NULL,
   `bairro` VARCHAR(30) NOT NULL,
   `cidade` VARCHAR(30) NOT NULL,
   `estado` CHAR(2) NOT NULL,
   `id_cliente` INT UNIQUE, 
   PRIMARY KEY (`idendereco`),
   Foreign key (`id_cliente` ) REFERENCES CLIENTE (`idcliete`));

  CREATE TABLE `comercio_udemy`.`telefone` (
  `idtelefon` INT NOT NULL AUTO_INCREMENT,
  `Tipo` ENUM('Com', 'Res', 'Cel') NULL,
  `Telefone` VARCHAR(10) NULL,
  `id_cliente` INT,
  PRIMARY KEY (`idtelefon`),
  Foreign key (`id_cliente` ) REFERENCES CLIENTE (`idcliente`));
  
  # Projeção, seleção e junção
  # Projeção: Tudo que quermos projetar na tela. Pode se construir
  # uma projeção ou trazer de uma tabela exemplo:
  
  # Projeção que foi construida
  select now() as "Data"; 
  
  # Projeção a partir de uma tabela
  select nome, now() as "Data" from cliente;
  
  # Seleção: é o subconjunto de um conjunto inteiro
  # exemplo de seleção:
  select nome, sexo
  from cliente
  where sexo = 'M';
  
  #exemplo de seleção para atualizar um dado:
  update cliente
  set sexo ='F'
  where idcliente = 5;

# junção: conjunto de informações de duas ou mais tabelas 
select nome, bairro, cidade, now() as "Data"
from cliente
inner join endereco
on idcliente = id_cliente
where bairro = 'Centro';

select c.nome, c.sexo, e.bairro, e.cidade, t.tipo, t.telefone
from cliente c
inner join endereco e
on c.idcliente = e.id_cliente
inner join telefone t
on c.idcliente = t.id_cliente;

# Exercicio:
# para uma campanha de marketing, o setor solicitou um
# relátorio com nome, email, e telefone celular dos clientes
# que moram no estado do Rio de Janeiro você tera que passar
# a query para gerar o relatorio para o programador

select c.nome, c.email, t.numero
from cliente c
inner join telefone t
on c.idcliente = t.id_cliente
inner join endereco e
on c.idcliente = e.id_cliente
where t.tipo = 'cel' and e.estado = 'rj'
;

select c.nome, 
	   ifnull(c.email,'sem email') as 'email',
       t.numero
from cliente c
inner join telefone t
on c.idcliente = t.id_cliente
inner join endereco e
on c.idcliente = e.id_cliente
where c.sexo = 'F' and e.estado = 'SP'
and  t.tipo = 'cel';

# Criando uma view
# View é uma função criada pelo o DBA para armazenar e instanciar 
# uma query que será utilizada varias vezes. Exemplo abaixo 

create view relatorio as 
select c.nome, 
	   ifnull(c.email,'sem email') as 'email',
       t.numero
from cliente c
inner join telefone t
on c.idcliente = t.id_cliente
inner join endereco e
on c.idcliente = e.id_cliente
where c.sexo = 'F' and e.estado = 'SP'
and  t.tipo = 'cel';

select * from relatorio;

select * from cliente
where sexo = 'f';

# Update: o comando update serve para alterar
# informações já registradas de uma tabela
update cliente
set email = 'celia@terra.com'
where idcliente = 6;

# Comando Order By
# Ele ira ordenar a tabela através do campo que 
# o DBA usou como parametro por exemplo 

select  nome,
		sexo,
        cpf,
        cidade
from cliente
inner join endereco
on idcliente = id_cliente
order by nome;

# É possível ordernar por mais de um campo 
select 	nome,
	   sexo,
       cpf,
       cidade
from cliente 
inner join endereco
on idcliente = id_cliente
order by nome, cpf;

# Para ordernar do menor par a o maior usa o 
# comando 'ASC'

select	nome,
		sexo,
        cpf,
        cidade
from cliente
inner join endereco
on idcliente = id_cliente
order by nome, cpf asc;

# ou ordenar através de colunas informando se é 
# a primeira, segunda ou etc.

select	nome,
		sexo,
        cpf,
        cidade
from cliente
inner join endereco
on idcliente = id_cliente
order by 4; # ira ordenar pela 4° coluna

# Delimitador: caractere que define o fim do comando
# de padrão é o ';'
# para alterar o Delimiter usa o comando abaixo
# delimiter novo delimitador. Segue exemplo abaixo

delimiter $
select * from cliente $
delimiter ;

# Estado do servidor: para checar as informações do servidor
# usa-se o comando Status
# STATUS COMERCIO_UDEMY;
status 

# Procedures
# Procedure é um bloco de programação dentro do banco de dados 
# segue exemplo abaixo de como criar um procedure 
# OBS: Sempre trocar o delimitador antes de criar a procedure

delimiter $
select nome from cliente $
create procedure conta()
begin
	select 10 + 10 as 'conta';
end
$

delimiter ;

# abaixo um exemplo de como chamar a procedure
# criada anteriormente
call conta();

# abaixo exemplo de como criar procedure 
# com parametro e como eliminar uma procedure

drop procedure conta;

delimiter $

create procedure conta(num1 int, num2 int )
begin
	select num1 + num2 as 'soma';
end
$

delimiter ;

call conta(10, 2);

# Junto query com procedure: 
# o bloco de notas para procedure pode se 
# usar comando SQL, siga abaixo exemplo 

create table cursos (
idcursos int primary key auto_increment,
nome varchar (30) not null,
horas int(3) not null,
valor float (10,2)
); 

insert cursos values(
null,
'Banco de dados fundamental',
25,
200.00
);

delimiter $

create procedure cad_curso(p_nome varchar(30), p_horas int(3), p_preco float (10,2) )
begin
	insert into cursos values(null, p_nome, p_horas, p_preco);
end $

delimiter ;

select * from cursos;

call cad_curso('BI - SQL Server', 35, 200.00);

delimiter $

create procedure sel_curso()
begin
	select idcursos,
		   nome,
           horas,
           valor
     from cursos;
 end $
 
 delimiter ;
 
 call sel_curso();
 
 # Funções de agregação: abaixo uma tabela de exemplo para 
 # mostrar como funciona as funções de agregação
 
create table vendedores(
idvendedor int primary key auto_increment,
nome varchar(30),
sexo char(1),
janeiro float(10,2),
fevereiro float(10,2),
marco float(10,2)
 );
 
insert into vendedores values(null,'Carlos','M',7234.78,88346.87,7753.90);
insert into vendedores values(null,'Maria','F',8434.78,88296.87,7000.90);
insert into vendedores values(null,'Antonio','M',6434.78,4353.87,1231.90);
insert into vendedores values(null,'Clara','F',8657.78,3442.87,45345.90);
insert into vendedores values(null,'Anderson','M',4535.78,3242.87,4324.90);
insert into vendedores values(null,'Ivone','F',9688.78,5645.87,6546.90);
insert into vendedores values(null,'João','M',2342.78,6857.87,4535.90);
insert into vendedores values(null,'Celia','F',5244.78,5234.87,5242.90);

# Função max: traz o maior valor de uma coluna
select max(fevereiro) as 'valor maximo de Fevereiro'
from vendedores;

# Função min: traz o menor valor de uma coluna
select min(fevereiro) as 'valor minimo de Feveireiro'
from vendedores;

#Função avg: traz a media de uma coluna
select avg(fevereiro) as 'media de vendas de Fevereiro'
from vendedores;

# Obs: Pode se usar mais de uma função na mesma query
# Siga o exemplo abaixo 
select max(fevereiro) as 'valor maximo de Fevereiro',
       min(fevereiro) as 'valor minimo de Feveireiro',
	   avg(fevereiro) as 'media de vendas de Fevereiro'
from vendedores;

# Função truncate: trunca um valor da coluna ela pede
# dois parametros o 1° parametro é um numero e o 2° a 
# quantidade de casas decimais

select truncate((fevereiro),2) as 'media de vendas de Fevereiro'
from vendedores;

# Função Sum: irá trazer a soma de uma coluna exemplo abaixo

select sum(fevereiro) as "total de vendas" from vendedores;

# Exemplo da função Sum com outros comandos do SQL.
select sexo, sum(fevereiro) as "total de vendas"
from vendedores
group by sexo;

# Subqueries: Simplesmente uma query dentro da outra 
# Por exemplo verificar o nome do vendedor que mais 
# vendeu em março.

select 	nome, 
		marco
from 	vendedores
where marco = (select max(marco) from vendedores);

# Vendedor que vendeu menos 
select	nome,
		marco
from	vendedores
where marco = (select min(marco) from vendedores);

# Vendedor que vendeu acima da media
select	nome,
		marco
from 	vendedores
where marco > (select avg(marco) from vendedores);

select 	nome,
		janeiro + fevereiro + marco as "total do trimestre"
from vendedores;

# Alterando estrutura das tabelas 
# Segue abaixo tabela de exemplo

create table tabela(
	coluna1 varchar(30),
    coluna2 varchar(30),
    coluna3 varchar(30)
);

#adicionando uma primary key 
alter table tabela
add primary key (coluna1);

# adicionando uma nova coluna sempre que 
# adicionar uma nova coluna sem indicar a
# sua posição na tabela, automaticamente ela 
# sera a última

alter table tabela
add coluna varchar(30);

# para escolher a posiçao da nova coluna 
# basta usar a sintaxe after para indicar a 
# coluna que ela será posterior 

alter table tabela
add column coluna4 varchar(30)
after coluna3;

# também é possível modificar o tipo da coluna 
# mas para isso os dados já inseridos deve ser 
# compativel com o novo tipo de dado que sera 
# imposto 

alter table tabela
modify coluna int(10);

# para renomear a tabela se usa o seguinte 
# comando 

alter table tabela
rename pessoa;

# será criado uma nova tabela para mostrar como
# se adiciona uma chave estrangeira após a criação

create table Time(
idtime int primary key auto_increment,
time varchar(30),
id_pessoa varchar(30)
);

# adicionando a Foreign Key 

alter table time
add foreign key (id_pessoa)
references tabela(coluna1);

# algumas tabelas serão apagadas para fazermos um
# exemplo de constraints 

drop table endereco;
drop table telefone;
drop table cliente;

# Constraints seria meio que as regras de um BD 
# através delas definimos quais será os relacionamentos 
# de uma tabela definindo suas PKs e FKs é considerado 
# um bom habito fazer os relacionamento delas devido a 
# organização que ela passar para o scrip 

create table cliente (
	idcliente int,
    nome varchar(30) not null
);

create table telefone(
	idtelefone int,
    tipo char(3),
    numero varchar(10) not null,
    id_cliente int 
);

alter table cliente add constraint PK_cliente
primary key (idcliente);

alter table telefone add constraint PK_telefone
primary key (idtelefone);

alter table telefone add constraint FK_cliente_telefone
foreign key (id_cliente) references cliente (idcliente);

# Trigger
# a Trigger vai executar uma ação em uma tabela após ou 
# antes de uma determinada ação abaixo o exemplo de estrutura 
# de uma trigger lembrando que é necessario mudar o delimter 
#
# create triggegr nome
# before / after / insert / delete/ update on tabela
# for each row
# begin
#	comando sql
#end

create table usuario(
	idusuario int primary key auto_increment,
    nome varchar(30),
    login varchar(30),
    senha varchar(100)
);

create table bkp_usuario(
	idbackup int primary key auto_increment,
    idusuario int,
    nome varchar (30),
    login varchar (30)
);

# Trigger criada usando o IDLE
DROP TRIGGER IF EXISTS `udemysql`.`backup_user`;

DELIMITER $$
USE `udemysql`$$
CREATE DEFINER = CURRENT_USER TRIGGER `udemysql`.`backup_user` 
BEFORE DELETE ON `usuario` FOR EACH ROW
BEGIN
	insert into bkp_usuario values (null, OLD.idusuario, OLD.nome, OLD.login);
END$$
DELIMITER ;

# É possível usar as triggers para efetuar um backup de banco de dados 
# exemplo a seguir 

create database exemplo_loja;
use exemplo_loja;

create table produto(
idproduto int primary key auto_increment,
nome varchar (30),
preco float (10,2)
);

create database exemplo_loja_backup;
use exemplo_loja_backup;

create table bkp_produto(
idbkp int primary key auto_increment,
idproduto int,
nome varchar (30),
valor_original float (10,2),
valor_alterado float (10,2),
data datetime,
usuario varchar(30),
evento char(1)
);

insert into exemplo_loja_backup.bkp_produto 
values (null, 1000, 'teste', 0.0);

# abaixo trigger que faz o backup de um banco de dados
# em outro 

DROP TRIGGER IF EXISTS `exemplo_loja`.`backup_produto`;

DELIMITER $$
USE `exemplo_loja`$$
CREATE DEFINER = CURRENT_USER TRIGGER `exemplo_loja`.`backup_produto` 
BEFORE INSERT ON `produto` FOR EACH ROW
BEGIN
	insert into exemplo_loja_backup.bkp_produto
    values (null, new.idproduto, new.nome, new.preco);
END$$
DELIMITER ;

insert into produto 
values (null, 'livro', 10.00);

insert into produto
values (null, 'jogo', 50.00);

insert into produto
values (null, 'tv', 1000.00);

select * from bkp_produto;

DROP TRIGGER IF EXISTS `exemplo_loja`.`produto_AFTER_UPDATE`;

DELIMITER $$
USE `exemplo_loja`$$
CREATE DEFINER = CURRENT_USER TRIGGER `exemplo_loja`.`produto_AFTER_UPDATE`
 AFTER UPDATE ON `produto`
 FOR EACH ROW
BEGIN
	insert into exemplo_loja_backup.bkp_produto
    values(null, OLD.idproduto, OLD.nome, OLD.preco, new.preco, now(), current_user(), 'u');
END$$
DELIMITER ;

select * from bkp_produto;

# Exercicio de auto relacionamento 

create table curso (
	idcurso int primary key auto_increment,
    nome varchar(30),
    carga_horaria int,
    preco float (10,2),
    id_curso int
);

alter table cursos add constraint fk_curso
foreign key (id_curso) references curso(idcurso);

select 	c.idcurso,
		c.nome,
        c.carga_horaria,
        c.preco,
        ifnull(p.nome, '-----') as 'pre requisito'
from 	curso c
left join curso p
 on c.idcurso = p.id_curso;
		
select * from curso;        

# abaixo terá um exemplo de cursores:
# cursores seriam como os vetores em programação 
# ele será usado para manipulação de saida dedados
# não é recomendavel usar sempre devido exigir muito
# da memoria do servidor.

create database cursores;
use cursores;

create table vendedores(
	idvendedores int primary key auto_increment,
    nome varchar (30),
    jan int,
    fev int,
    mar int
);

select nome, (jan+ fev + mar) as 'total' from vendedores;

create table total(
	idtotal int primary key auto_increment,
    nome varchar (30),
    jan int,
    fev int,
    mar int,
    total int,
    media int
);

USE `cursores`;
DROP procedure IF EXISTS `inseredados`;

DELIMITER $$
USE `cursores`$$
CREATE PROCEDURE `inseredados` ()
BEGIN
	declare fim int default 0;
    declare var1, var2, var3, vmedia, vtotal int;
    declare vnome varchar(30);
    
    declare reg cursor for(
    select nome, jan, fev, mar from vendedores
    );
    
    declare continue handler for not found set fim = 1;
    
    open reg;
    
    repeat
    
		fetch reg into vnome, var1, var2, var3;
        if not fim then 
			set vtotal = var1 + var2 + var3;
			set vmedia = vtotal / 3;
            insert into total values( null, vnome,var1, var2, var3, vtotal, vmedia);
		end if;
	until fim end repeat;
    close reg;    
END$$

DELIMITER ;

call inseredados();

select * from total;


# exercicio sobre 2° e 3° forma normal 

create database consultorio;
use consultorio;

create table paciente(
	idpaciente int primary key auto_increment,
    nome varchar(30),
    sexo char(1),
    email varchar(30),
    nascimento date
);

create table medico(
	idmedico int primary key auto_increment,
    nome varchar(30),
    sexo char(1),
    especialidade varchar(30),
    funcionario enum ('S','N')
);

create table hospital(
	idhospital int primary key auto_increment,
    nome varchar(30),
    bairro varchar(30),
    cidade varchar(30),
    estado char(2)
);

create table consulta(
	idconsulta int primary key auto_increment,
    id_paciente int,
    id_medico int,
    id_hospital int,
    date datetime,
    diagnostico varchar(50)
);

create table internacao(
	idinternacao int primary key auto_increment,
    entrada datetime,
    quarto int,
    saida datetime,
    observacao varchar(50),
    id_consulta int unique
);

alter table consulta 
add constraint fk_consulta_paciente
foreign key(id_paciente)
references paciente (idpaciente);

alter table consulta
add constraint fk_consulta_medico
foreign key(id_medico)
references medico(idmedico);

alter table consulta
add constraint  fk_consulta_hospital
foreign key(id_hospital)
references hospital(idhospital);

alter table internacao
add constraint fk_internacao_consulta
foreign key(id_consulta)
references consulta(idconsulta);


/* Exercicios */

CREATE SCHEMA `livraria` ;

CREATE TABLE `livraria`.`livro` (
  `idlivro` INT NOT NULL AUTO_INCREMENT,
  `titulo` VARCHAR(45) NOT NULL,
  `paginas` INT(4) NOT NULL,
  `valor` FLOAT(5,2) NOT NULL,
  `id_autor` VARCHAR(45) NOT NULL,
  `id_editora` VARCHAR(45) NULL,
  PRIMARY KEY (`idlivro`));

CREATE TABLE `livraria`.`autor` (
  `idautor` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `sexo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idautor`));

CREATE TABLE `livraria`.`editora` (
  `ideditora` INT NOT NULL,
  `nome` VARCHAR(45) NOT NULL,
  `uf` CHAR(2) NOT NULL,
  PRIMARY KEY (`ideditora`));

alter table `livraria`.`livro` add constraint fk_livro_autor
foreign key (id_autor) references autor (idautor);

alter table `livraria`.`livro` add constraint fk_livro_editora
foreign key (id_editora)  references editora (ideditora);

create view dados_livros as
	select 	idlivro, 
			titulo, 
            paginas,
            valor,
            id_autor,
            id_editora
	from livro;

create view tituloLivro_nomeEditora as
	select	l.titulo,
			e.nome
	from livro l
    inner join editora e
    on id_editora = idlivro;

create view v_livro_editora_uf_autor as
	select 	l.titulo,
			l.uf
	from livro l
    inner join  autor a
	on l.id_autor = a.idautor
    where a.sexo = 'M';


select * from dados_livros;
select * from tituloLivro_nomeEditora;
select * from v_livro_editora_uf_autor;