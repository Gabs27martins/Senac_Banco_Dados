alter table profissional
	add column dataAdm datetime not null;
    
alter table profissional
	add column sexo char(1) not null;
 
alter table profissional
	add column salario decimal(5,2) not null;
    
alter table paciente
	add column idade int null;

alter table registrofatura
	change column custo valor decimal(6,2) not null,
    change column planoSaude planoSaude char(1) not null;
    
alter table profissional
	change column registroProf cargo varchar(45) not null;
    
alter table segurosaude
	change column nomeSegurado nomeSeguro varchar(45) not null;
    
alter table segurosaude
	add column tipoSeguro varchar(20) not null;

alter table telefonepaciente
	add column operadora varchar(20) not null;
    
alter table telefonepaciente
	drop column operadora;

alter table profissional
	change column salario salario decimal(7,2) not null;
    
alter table procedimentoodonto
	change column nome nome varchar(60) not null;
	
alter table procedimentoodonto
	change column custo custo decimal(6,2) not null;
    
alter table gerente
	change column comissao comissao decimal(6,2) not null;	
    
