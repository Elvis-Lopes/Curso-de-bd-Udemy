/* Criando um banco de dados */
create database aula_sql

/* Conectando a um banco de dados */
use aula_sql

/* Criando tabela */
create table exemplo(
	nome varchar(30)
)

/* o SQL Serve ele não executa os comandos na ordem 
   para que seja executadar em ordem usar o script
   em ordem usar o comando 'go' como se fosse o delimitador*/

/* organizando um banco de dados fisicamento e logicamente

1- criar um banco com arquivos para os setores de mkt e rh
2- criar um arquivo geral
3- deixar o MDF apenas como dicionario de dados
4- criar dois grupos de arquivos */

   create table TB_EMPRESA(
		id int,
		nome varchar(50)
   )
   go

/* No SQL Server ao criar uma chave primaria se usa o 
   comando 'identy' no lugar do auto_increment */
create table ALUNO(
	idaluno int primary key identity,
	nome varchar(30)not null,
	sexo char(1) not null,
	nascimento date,
	email varchar(30) unique
)
go

/* Constraints */

/* a Constraint abaixo verifica se a informação inserida
   respeita a regra de negocio ( como se fosse a função
   ENUM no MySQL )*/

alter table aluno
add constraint ck_sexo 
check (sexo in('M','F'))
go

create table ENDERECO(
	idendereco int primary key identity(100, 10),
	bairro varchar(30),
	uf varchar(2) not null,
	id_aluno int unique
)
go

alter table endereco
add constraint fk_endereco_aluno
foreign key(id_aluno) 
references aluno (idaluno)
go

alter table endereco
add constraint ck_uf
check(uf in ('SP','MG','RJ'))
go

/* Comandos de descrição 
   
   para o SQL Server são procedures já criadas que fazem
   as ações de consulta, exemplos abaixo*/

sp_columns aluno
go

sp_help aluno
go

/* inserindo dados */
insert into aluno 
values ('Andre','M','1981/05/23','Andreig@teste.com')
insert into aluno 
values ('Ana','F','1978/05/23','ana@teste.com')
insert into aluno 
values ('Rui','M','1990/05/23','Rui@teste.com')
insert into aluno 
values ('João','M','1996/05/23','Joao@teste.com')
go

insert into ENDERECO
values('Flamengo','RJ',1)
insert into ENDERECO
values('Morumbi','SP',2)
insert into ENDERECO
values('Centro','MG',3)
insert into ENDERECO
values('Centro','SP',4)
go

/* Criando tabela telefone*/

create table TELEFONE(
	idtelefone int primary key identity,
	tipo char(3) not null,
	numero varchar(10) not null,
	id_aluno int,
	check(tipo in ('Res','Cel','Com'))
)
go

insert into TELEFONE
values('cel','7899889',1)

insert into TELEFONE
values('res','4325444',1)

insert into TELEFONE
values('com','4354354',2)

insert into TELEFONE
values('cel','234456',2)
go

/* pegar data atual no sistema*/

select GETDATE()
go

/* clausula ambigua*/

select	a.nome,
		t.tipo,
		t.numero,
		e.bairro,
		e.uf
from ALUNO a
left join telefone t
on a.idaluno = t.id_aluno
inner join ENDERECO e
on a.idaluno = e.id_aluno
go

/* ifnull */
select	a.nome,
		isnull(t.tipo,'sem') as "Tipo",
		isnull(t.numero,'numero') as "Numero",
		e.bairro,
		e.uf
from ALUNO a
left join telefone t
on a.idaluno = t.id_aluno
inner join ENDERECO e
on a.idaluno = e.id_aluno
go

/* Datas */
select * from ALUNO
go

/* Datediff: calcula a diferença entre duas datas.
   Getdate: traz dia e hora atual no sistema*/
select nome, GETDATE() as "Data_hora"
from aluno 
go

select nome, DATEDIFF(DAY, nascimento, GETDATE()) as "Intervalo de dias"
from ALUNO
go

/* usando o datediff com operação matematica*/
select	nome, 
		(DATEDIFF(DAY, nascimento, GETDATE())/365) as "Intervalo de dias"
from ALUNO
go

/* Datename: traz o nome da parte da data em questão */
select	nome,
		DATENAME(MONTH, nascimento)
from ALUNO
go

/* Datepart: faz o mesmo do datename porém ele traz um inteiro
	essa função é usado para fazer calculo*/
select	nome,
		DATEPART(MONTH, nascimento)
from ALUNO
go

/* Dateadd: soma duas datas*/
select DATEADD(DAY, 365, GETDATE())
from ALUNO
go

/* Conversão de dados
   No SQL Server tem conversão automatica de string para numerico
   e também tem funções de conversão.*/

/* Função Cast: converte o valor inserido para int*/

select CAST('1' as int) + CAST('1' as int)
go

/*Concatenação*/

select	nome,
		CAST(DAY(nascimento) as varchar) + '/'
		+ CAST(MONTH(nascimento) as varchar)+ '/'
		+CAST(YEAR(nascimento) as varchar) as "nascimento"	
from ALUNO
go

/* Charindex - retorna um valor inteiro baseado em uma busca
   Contagem default: se inicia em 1 */

select nome, CHARINDEX('A',nome) as "indice"
from ALUNO
go

/* Charindex com o terceiro parametro*/
select nome, CHARINDEX('A',nome, 2) as "indice"
from ALUNO
go

/* Bulk insert - importanto arquivos */

create table lancamento_contabil(
	conta int,
	valor int,
	deb_cred char(1)
)
go

/* importanto o arquivo com bulk insert*/


bulk insert lancamento_contabil
from 'C:\Users\elvis\Downloads\CONTAS.txt'
with(
	firstrow = 2,
	datafiletype = 'char',
	fieldterminator = '\t',
	rowterminator = '\n'
)
go

select * from lancamento_contabil
go

/* desafio do saldo
	query que traga o numero da conta
	saldo - devedor ou credor*/

select	conta,
		valor,
		charindex('D', deb_cred) as debito,
		charindex('C', deb_cred) as credito,
		charindex('C', deb_cred)*2 - 1 as multiplicador
from lancamento_contabil
go

select	conta,
		SUM(valor * (CHARINDEX('C', deb_cred)*2-1)) as saldo
from lancamento_contabil
group by conta
go

/* triggers
	OBS.: as tabelas criadas estaram no bd 'Empresa'
*/

create table produtos(
	idproduto int identity primary key,
	nome varchar(50) not null,
	categoria varchar(30) not null,
	preco numeric(10,2) not null,
	/* no SQL Server não tem o tipo de dado float no lugar e o numeric*/
)
go

create table historico(
	idoperaco int identity primary key,
	produto varchar(50) not null,
	categoria varchar(30) not null,
	preco_antigo numeric(10,2) not null,
	preco_novo numeric(10,2) not null,
	data datetime,
	usuario varchar(30),
	mensagem varchar(30)
)
go

insert into produtos values ('Livro SQL Server','Livros',98.00)
insert into produtos values ('Livro Oracle','Livros',50.00)
insert into produtos values ('Livro Oracle','Livros',50.00)
insert into produtos values ('Licença Power Center','Software', 45000.00)
insert into produtos values ('Notebook','Computadores', 3150.00)
insert into produtos values ('Livro Business Intelligence','Livros',90.00)
go

/* Verificando o usuario do BD*/

select USER_NAME();
go

/*Trigger de dados - data manipulation language*/
/* nome da trigger*/
create trigger TRG_ATUALIZA_PRECO
/* em qual tabela irá ocorrer*/
on dbo.produtos
/* ação que vai startar */
for update
as
if UPDATE(preco)
begin
	/*Declarando variaveis*/
	declare @idproduto int
	declare @produto varchar(30)
	declare @categoria varchar(10)
	declare @preco numeric(10,2)
	declare @preconovo numeric(10,2)
	declare @data datetime
	declare @usuario varchar(30)
	declare @acao varchar(100)

	/*passando valores informações para a variavel*/
	select @idproduto = idproduto from inserted
	select @produto = nome from inserted
	select @categoria = categoria from inserted
	select @preco = preco from deleted
	select @preconovo = preco from inserted
	
	/*inserindo informações do Sistema nas variaveis*/
	set @data = GETDATE()
	set @usuario = SUSER_NAME()
	set @acao = 'Valor inserido pela Trigger TRG_ATUALIZA_PRECO'
	
	/*inserindo valores na nova tabela*/
	insert into historico(
		produto,
		categoria,
		preco_antigo,
		preco_novo,
		data,
		usuario,
		mensagem)
	values(
		@produto,
		@categoria,
		@preco,
		@preconovo,
		@data,
		@usuario,
		@acao
	)

	/*Função que imprime uma mensagem na tela */
	print 'trigger executada com sucesso'
end
go

/*executando update*/
update produtos set preco = 120.00
where idproduto  = 1
go

select * from historico
go

/*Trigger de dados - data manipulation language*/
/* nome da trigger*/
create trigger TRG_ATUALIZA_PRECO
/* em qual tabela irá ocorrer*/
on dbo.produtos
/* ação que vai startar */
for update
as
begin
	/*Declarando variaveis*/
	declare @idproduto int
	declare @produto varchar(30)
	declare @categoria varchar(10)
	declare @preco numeric(10,2)
	declare @preconovo numeric(10,2)
	declare @data datetime
	declare @usuario varchar(30)
	declare @acao varchar(100)

	/*passando valores informações para a variavel*/
	select @idproduto = idproduto from inserted
	select @produto = nome from inserted
	select @categoria = categoria from inserted
	select @preco = preco from deleted
	select @preconovo = preco from inserted
	
	/*inserindo informações do Sistema nas variaveis*/
	set @data = GETDATE()
	set @usuario = SUSER_NAME()
	set @acao = 'Valor inserido pela Trigger TRG_ATUALIZA_PRECO'
	
	/*inserindo valores na nova tabela*/
	insert into historico(
		produto,
		categoria,
		preco_antigo,
		preco_novo,
		data,
		usuario,
		mensagem)
	values(
		@produto,
		@categoria,
		@preco,
		@preconovo,
		@data,
		@usuario,
		@acao
	)

	/*Função que imprime uma mensagem na tela */
	print 'trigger executada com sucesso'
end
go


/*Segundo exemplo de trigger de update*/

create table empregado(
	idempregado int primary key identity,
	nome varchar(30),
	salario money,
	idgerente int
)
go

alter table empregado add constraint fk_gerente
foreign key (idgerente) references empregado(idempregado)
go

insert into empregado values ('Clara', 5000.00, null)
insert into empregado values('Celia',4000.00,1)
insert into empregado values('João',4000.00,1)
go

create table hist_salario(
	idempregado int ,
	antigosal money,
	novosal money,
	data datetime
)
go

create trigger trg_salario
on dbo.empregado
for update as
if update(salario)
begin
	insert into hist_salario
	(idempregado, antigosal, novosal, data)
	select d.idempregado, d.salario, i.salario, GETDATE()
	from deleted d, inserted i
	where d.idempregado = i.idempregado
end
update empregado set salario = salario * 1.1
go

/* Triggers de range*/

create table salario_range(
	minsal money,
	mansal money
)
go

insert into salario_range values(3000.00, 6000.00)
go

create trigger tg_range
on dbo.empregado
for insert, update
as
	declare
		@minsal money,
		@maxsal money,
		@atual_sal money

	select @minsal = minsal, @maxsal = mansal from salario_range

	select @atual_sal = i.salario
	from inserted i

	if(@atual_sal < @minsal)
	begin
		raiserror('Salario menor que o piso',16,1)
		rollback transaction
	end

	if(@atual_sal > @maxsal)
	begin
		raiserror('Salario maior que o teto',16,1)
		rollback transaction
	end

update empregado set salario = 9000.00
where idempregado = 1
go

/* verificando texte de uma trigger*/
sp_helptext tg_range
go

create table pessoa(
	idpessoa int primary key identity,
	nome varchar(30) not null,
	sexo char(1) not null check (sexo in ('M','F')),
	nascimento date not null
)
go

create table telefone(
	idtelefone int not null identity,
	tipo char(3) not null check(tipo in ('Cel','Com')),
	numero char(10) not null,
	id_pessoa int
)
go

alter table telefone add constraint fk_telefone_pessoa
foreign key(id_pessoa) references pessoa(idpessoa)
go

insert into pessoa values ('Antonio','M','1981-02-13')
insert into pessoa values ('Daniel','M','1985-03-18')
insert into pessoa values ('Cleide','F','1979-10-13')

insert into TELEFONE values('Cel','9879008',1)
insert into TELEFONE values('Com','9879009',1)
insert into TELEFONE values('Cel','9899008',2)
insert into TELEFONE values('Cel','9679009',2)
insert into TELEFONE values('Com','9579008',3)
insert into TELEFONE values('Com','9879509',2)
insert into TELEFONE values('Cel','9879409',3)
go

/* criando a procedure */

create proc soma
as
	select 10 + 10 as soma
go

/*execução da procedure*/
soma
go

/* Dinamicas - com parametros*/

create proc conta @num1 int, @num2 int
as
	select @num1 + @num2
go 

/* executando */

exec conta 90, 78
go

/* procedure em tabelas*/

select nome, numero
from pessoa
inner join TELEFONE
on idpessoa = id_pessoa
where tipo = 'cel'
go

/* trazer os telefones de acordo com o tipo passado */
create proc telefones @tipo char(3)
as
	select nome, numero
	from pessoa
	inner join TELEFONE
	on idpessoa = id_pessoa
	where tipo = @tipo
go

exec telefones 'cel'
go


/* parametros de output */


select tipo, count(*) as quantidade
from TELEFONE
group by tipo
go

create proc gettipo @tipo char(3), @contador int output
as
	select @contador = count(*)
	from telefone
	where tipo = @tipo
go

declare @saida int
exec gettipo @tipo = 'cel', @contador = @saida output
select @saida
go

/* Procedure de cadastro */

create proc cadastro @nome varchar(30), @sexo char(1), @nascimento date,
@tipo char(3), @numero varchar(10)
as 
	declare  @FK int

	insert into pessoa values(@nome, @sexo, @nascimento)

	set @fk = (select idpessoa from pessoa where idpessoa = @@IDENTITY)

	insert into TELEFONE values (@tipo, @numero, @FK)
go

cadastro 'Jorge','M','1981-01-01','Cel','918294'
go

select pessoa.*, TELEFONE.*
from pessoa
inner join TELEFONE
on idpessoa = id_pessoa
go

/* TSQL exemplos*/

/* Bloco de execução */
begin
	print 'Primeiro bloco'
end
go

/* Bloco de atribuição de variaveis */

declare
	@contador int
begin
	set @contador = 5
	print @contador
end
go

/*	No SQL Server cada coluna variavel local expressão 
	parmetro tem um tipo */

declare
	@v_numero numeric(10, 2) = 100.52,
	@v_data datetime = '20170207'
begin
	print 'Valor numerico ' + cast(@v_numero as varchar)
	print 'valor numerico' + convert(varchar, @v_numero)
	print 'Valor de data: ' +cast(@v_data as varchar)
	print 'Valor de data: ' + convert(varchar, @v_data, 105)
end
go

create table carros(
	carro varchar(20),
	fabricante varchar(30)
)
go

insert into carros values('KA','ford')
insert into carros values('Fiesta','ford')
insert into carros values('Prisma','ford')
insert into carros values('Clio','Renault')
insert into carros values('Sandero','Renault')
insert into carros values('Chevete','Chevrolet')
insert into carros values('Omega','Chevrolet')
insert into carros values('palio','Fiat')
insert into carros values('doblo','Fiat')
insert into carros values('uno','Fiat')
insert into carros values('gol','volkswagen')
go

declare
	@v_cont_ford int,
	@v_cont_fiat int
begin
	--Metodo 1 - O selecct precisa retornar uma simples coluna
	-- E um resultado
	set  @v_cont_ford = (select COUNT(*) from carros
	where fabricante = 'ford')

	print 'quantidade Ford:' + cast(@v_cont_ford as varchar)

	--Metodo 2
	select @v_cont_fiat = COUNT(*) from carros where fabricante = 'Fiat'

	print 'quantidade fiat: ' + convert(varchar, @v_cont_fiat)
end
go

/* if - else*/
declare 
	@numero int = 6
begin
	if @numero = 5
		print 'o valor é verdadeira'
	else
		print 'o valor é falso'
end
go

/* case */
declare
	@contador int
begin
	select
	case
		when fabricante = 'fiat' then 'Faixa 1'
		when fabricante = 'chevrolet' then 'faixa 2'
		else 'outras faixas'
	end as "Informações",
	* from carros
end
go

/* Loop em while*/
declare 
	@i int = 1
begin
	while (@i <15)
	begin
		print 'Valor de @i:' + cast(@i as varchar)
		set @i = @i + 1
	end
end
go