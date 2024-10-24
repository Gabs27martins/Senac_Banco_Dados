#Relatorio com  a quantidade de seguros saúde por paciente#
select pac.rg "RG", 
	pac.nome "Paciente",
	coalesce(count(pacseg.segurosaude_idsegurosaude), 0) "Numero de planos"
    from paciente pac
		left join paciente_tem_segurosaude pacseg on pacseg.paciente_rg = pac.rg
			group by pac.rg
				order by count(pacseg.segurosaude_idsegurosaude) desc;

#Relatorio número de registro clinicos por dentista#
select dent.cro "Registro Profissional",
	  prof.nome "Nome",
	  coalesce(count(regclinpac.registroclinico_idregistroclinico),0) "Histórico Atendimentos"
      from dentista dent
		  inner join profissional prof on prof.cpf = dent.profissional_cpf
		  inner join registroclinicopaciente regclinpac on regclinpac.dentista_profissional_cpf = dent.profissional_cpf
				group by dent.cro
					order by count(regclinpac.registroclinico_idregistroclinico) desc;
                
#Relatorio de frequência de receita acima da meta no balanço por gerente, considerando a média como meta#
select prof.cpf "Registro do Gerente",
		prof.nome "Nome",
		concat('R$ ', format(sum(prof.salario + ger.comissao), 2, 'de_DE')) "Investimento Salarial + Comissão",            
		count(bal.receita) "Receitas acima da meta"
		from gerente ger  			
		  inner join balanco bal on bal.gerente_profissional_cpf = ger.profissional_cpf
		  inner join profissional prof on prof.cpf = ger.profissional_cpf
			where receita > (select avg(receita) from balanco)
				group by ger.profissional_cpf
					order by count(bal.receita) desc; 
                
#Relatorio para entrar em contato com os pacientes atendidos que informaram telefone para contato#                
select pac.rg "Registro Paciente",
	pac.nome "Paciente",
	telpac.numero "Contato"
	from paciente pac
		inner join telefonepaciente telpac on telpac.paciente_rg = pac.rg
		inner join registroclinicopaciente regclinpac on regclinpac.paciente_rg = pac.rg
			group by pac.rg
				order by pac.nome;
                
                
#Relatorio para campanha de marketing com os pacientes que foram atendidos, sendo necessário os endereços#                
select pac.rg "Registro Paciente",
	pac.nome "Paciente",
	endpac.cep "CEP para envio"
	from paciente pac
		inner join enderecopaciente endpac on endpac.paciente_rg = pac.rg
		inner join registroclinicopaciente regclinpac on regclinpac.paciente_rg = pac.rg
			group by pac.rg
				order by pac.nome;
            
#Relatorio para verificar quantos anos de trabalho tem os dentistas que recebem acima da média #
select prof.nome "Nome",
	timestampdiff(year,prof.dataAdm, now()) "Tempo de trabalho em Anos",
	concat('R$ ', format(prof.salario, 2, 'de_DE')) "Salário"
	from profissional prof
		inner join dentista dent on  dent.Profissional_CPF = prof.CPF
			where salario > (select avg(salario) from profissional)
				order by timestampdiff(year, prof.dataAdm, now()) desc;
                
#Relatorio dos tipos de procedimentos realizados por dentista e a frequência, verificando a versatilidade dos dentista#
select prof.cpf "Matrícula",
	prof.nome "Nome",
    agend.tipoProcedimento "Tipo Procedimento",
    count(agend.tipoProcedimento) "Frequência do Procedimento"
	from agendamento agend
		inner join dentista dent on dent.profissional_cpf = agend.dentista_profissional_cpf
        inner join profissional prof on prof.cpf = dent.profissional_cpf
			group by agend.tipoProcedimento
				order by prof.nome;
                
#Relatorio para verificar informações dos dentistas e quanto tempo de trabalho na clínica#
select dent.cro "CRO",
	prof.nome "Nome",
    prof.cpf "Matrícula",
    timestampdiff(year,prof.dataAdm, now()) "Tempo de trabalho em Anos"
	from profissional prof
		inner join dentista dent on  dent.Profissional_CPF = prof.CPF
			order by timestampdiff(year, prof.dataAdm, now()) desc;
 
 #Relatorio para verificar a igualdade salarial entre os gêneros, utilizando a média do salário como parâmetro#
 select prof.sexo "Sexo",
	count(prof.cpf) "Número de Funcionários" 
	from profissional prof
		where salario > (select avg(salario) from profissional)
			group by prof.sexo
				order by count(prof.cpf) desc;
                
#Relatório para verificar qual a forma de pagamento que tem o maior faturamento#                
 select regfat.metodoPagamento "Método Pagamento",
	concat('R$ ', format(sum(regfat.valor), 2, 'de_DE')) "Valor por Método",
    count(pac.rg) "Número Paciente por Método"
	from registrofatura regfat
		inner join paciente pac on pac.rg = regfat.paciente_rg
		group by regfat.metodoPagamento
			order by sum(regfat.valor) desc;
            
#Relatório para verificar qual a forma de pagamento os pacientes com plano de saude mais utilizam#
 select regfat.metodoPagamento "Método Pagamento",
	concat('R$ ', format(sum(regfat.valor), 2, 'de_DE')) "Valor por Método",
    count(pac.rg) "Número Paciente por Método"
	from registrofatura regfat
		inner join paciente pac on pac.rg = regfat.paciente_rg
			where regfat.planoSaude = 'S'
				group by regfat.metodoPagamento
					order by sum(regfat.valor) desc, count(pac.rg) desc;
 
 #Relatório contabilizando o número de laboratórios cadastrados por gerente#
 select prof.cpf "Matrícula",
	prof.nome "Nome",
    count(lab.cnpj) "Laboratórios cadastrados"
	from profissional prof
		inner join gerente ger on ger.profissional_cpf = prof.cpf
		inner join laboratorio lab on lab.gerente_profissional_cpf = ger.profissional_cpf
			group by prof.cpf
				order by count(lab.cnpj) desc;
                
# Relatório com informações dos pacientes com os números de registros clinicos#
select pac.nome "Nome Paciente",
	pac.email "Email Paciente",
    pac.idade "Idade Paciente",
    count(rgclipac.registroclinico_idregistroclinico) "Número de atendimentos"
	from paciente pac
		inner join registroclinicopaciente rgclipac on rgclipac.paciente_rg = pac.rg
			group by pac.rg
				order by count(rgclipac.registroclinico_idregistroclinico) desc;
                
# Relatório com informações dos procedimentos com o valor acima da média#
select proced.nome "Nome Procedimento",
	concat('R$ ', format(proced.custo, 2, 'de_DE')) "Custo Procedimento"
	from procedimentoodonto proced
		where proced.custo > (select avg(procedimentoodonto.custo) from procedimentoodonto)
			group by proced.codigoProced
				order by sum(proced.custo) desc;
                
#Relatório com informações da seguradora incluindo o email#
select seg.nomeSeguro "Nome Seguradora",
	seg.apolice "Apolice Seguro",
    seg.cobertura "Cobertura",
    seg.tipoSeguro "Tipo Plano Saúde",
    emseg.email "Email"
	from segurosaude seg
		left join emailseguradora emseg on emseg.seguroSaude_idSeguroSaude = seg.idSeguroSaude			
				order by seg.nomeSeguro;
                
 #Relatório para verificar qual o tipo de seguro saúde quem tem o maior número de pacientes cobertos#
 select seg.tipoSeguro "Tipo Plano Saúde",
	count(pacseg.paciente_rg) "Número de Pacientes com plano"
	from segurosaude seg
		inner join paciente_tem_segurosaude pacseg on pacseg.seguroSaude_idSeguroSaude = seg.idSeguroSaude
			group by seg.tipoSeguro
				order by count(pacseg.paciente_rg) desc;
                
#Relatório para verificar qual a forma de pagamento os pacientes sem plano de saude mais utilizam#
 select regfat.metodoPagamento "Método Pagamento",
	concat('R$ ', format(sum(regfat.valor), 2, 'de_DE')) "Valor por Método",
    count(pac.rg) "Número Paciente por Método"
	from registrofatura regfat
		inner join paciente pac on pac.rg = regfat.paciente_rg
			where regfat.planoSaude like 'N'
				group by regfat.metodoPagamento
					order by sum(regfat.valor) desc, count(pac.rg) desc;
                    
#Relatório para verificar quantos funcionários por cargo tem mais de 40 anos#
select prof.cargo "Cargo",
	count(prof.cpf) "Número de Profissionais Acima dos 40"
	from profissional prof
		where timestampdiff(year,prof.dataNasc, now()) > 40
			group by prof.cargo
				order by count(prof.cpf) desc;
                
 #Relatório para verificar quais os últimos 5 agendamentos e quais os dentistas foram responsáveis# 
 select prof.cpf "Matrícula",
	prof.nome "Nome",    
    date_format(agend.dataHora, "%d/%m/%Y") "Data Agendamento"
	from agendamento agend
		inner join dentista dent on dent.profissional_cpf = agend.dentista_profissional_cpf
        inner join profissional prof on prof.cpf = dent.profissional_cpf			
			order by agend.dataHora desc
				limit 5;
                
 # Relatório para verificar quantos balanços tiveram receita após a despesa da folha de pagamentos, agrupando por gerente#
select prof.nome "Gerente Responsável",
	prof.cpf "Mátricula",
	count(bal.idbalanco) "Balanços com Receita maior que Folha Pagamento"
	from balanco bal
		inner join gerente ger on ger.profissional_cpf = bal.gerente_profissional_cpf
        inner join profissional prof on prof.cpf = ger.profissional_cpf
			where bal.receita > bal.folhaPag
				group by prof.cpf
					order by count(bal.idbalanco);