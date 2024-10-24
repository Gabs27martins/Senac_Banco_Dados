SET SQL_SAFE_UPDATES = 0;

update paciente
 set idade = year(now()) - year(dataNasc);
 
update gerente
	set comissao = 1.1 * comissao;
    
delete from enderecopaciente
		where paciente_rg = '2432109';

update enderecoprofissional        
	set complemento = 'Apt 101'
		where profissional_cpf = '28765432109';
        
update laboratorio
	set email = 'sorissoverde@gmail.com'
       where cnpj = '56.789.012/0001-94';

delete from laboratorio
		where cnpj = '90.123.456/0001-98';
        
update segurosaude
	set tipoSeguro = 'individual'
		where idSeguroSaude = 8;
        
delete from segurosaude
		where idSeguroSaude = 5;
        
update profissional
	set dataAdm = '2013-01-10 00:00:00'
		where cpf = '45678901234';
        
update registrofatura
	set valor = valor * 1.2
		where paciente_rg = '8901234';
        
 delete from registrofatura
	where idRegistroFatura = 7;
    
 delete from telefoneseguradora
	where idTelefoneSeguradora = 1;
    
 update telefonepaciente
	set numero = '(82) 90139-0001'
		where idTelefonePaciente = 1;
        
update procedimentoodonto
	set custo = 1.7 * custo
		where codigoProced = 1;
        
update telefonelaboratorio
	set numero = '(81) 99333-2020'
		where idTelefoneLaboratorio = 12;
        
update agendamento
	set dataHora = '2023-09-17 12:30:00'
		where idAgendamento = 1;
        
update agendamento
	set estadoConsulta = 'Emergência'
		where idAgendamento = 5;
        
update balanco
	set custoOperacional = custoOperacional * 0.8
		where idBalanco = 2;
        
update registroclinico
	set recomendacao = 'Retornar à clínica em 5 dias'
		where idRegistroClinico = 6;
        
update paciente_tem_segurosaude
	set paciente_rg = '2345678'
		where seguroSaude_idSeguroSaude = 10 and paciente_rg = '0987654';