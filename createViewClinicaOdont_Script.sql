create view relatorioPacientePlanos as 
	select pac.rg "RG", 
		pac.nome "Paciente",
		coalesce(count(pacseg.segurosaude_idsegurosaude), 0) "Numero de planos"
		from paciente pac
			left join paciente_tem_segurosaude pacseg on pacseg.paciente_rg = pac.rg
				group by pac.rg
					order by count(pacseg.segurosaude_idsegurosaude) desc;
                    
create view relatorioDentistaRegClinico as
	select dent.cro "Registro Profissional",
	  prof.nome "Nome",
	  coalesce(count(regclinpac.registroclinico_idregistroclinico),0) "Histórico Atendimentos"
      from dentista dent
		  inner join profissional prof on prof.cpf = dent.profissional_cpf
		  inner join registroclinicopaciente regclinpac on regclinpac.dentista_profissional_cpf = dent.profissional_cpf
				group by dent.cro
					order by count(regclinpac.registroclinico_idregistroclinico) desc;
                    
create view relatorioBalancoMeta as
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
                    
                    
create view relatorioVersatilidadeDent as
	select prof.cpf "Matrícula",
	prof.nome "Nome",
    agend.tipoProcedimento "Tipo Procedimento",
    count(agend.tipoProcedimento) "Frequência do Procedimento"
	from agendamento agend
		inner join dentista dent on dent.profissional_cpf = agend.dentista_profissional_cpf
        inner join profissional prof on prof.cpf = dent.profissional_cpf
			group by agend.tipoProcedimento
				order by prof.nome;
                
create view realatorioIgualdadeGen as
	select prof.sexo "Sexo",
	count(prof.cpf) "Número de Funcionários" 
	from profissional prof
		where salario > (select avg(salario) from profissional)
			group by prof.sexo
				order by count(prof.cpf) desc;
                
create view relatorioFaturamentoMetPag as
	select regfat.metodoPagamento "Método Pagamento",
	concat('R$ ', format(sum(regfat.valor), 2, 'de_DE')) "Valor por Método",
    count(pac.rg) "Número Paciente por Método"
	from registrofatura regfat
		inner join paciente pac on pac.rg = regfat.paciente_rg
		group by regfat.metodoPagamento
			order by sum(regfat.valor) desc;
            
 create view relatorioPacienteRegCli as
	select pac.nome "Nome Paciente",
	pac.email "Email Paciente",
    pac.idade "Idade Paciente",
    count(rgclipac.registroclinico_idregistroclinico) "Número de atendimentos"
	from paciente pac
		inner join registroclinicopaciente rgclipac on rgclipac.paciente_rg = pac.rg
			group by pac.rg
				order by count(rgclipac.registroclinico_idregistroclinico) desc;

create view relatorioTipoPlanPaciente as 
	select seg.tipoSeguro "Tipo Plano Saúde",
	count(pacseg.paciente_rg) "Número de Pacientes com plano"
	from segurosaude seg
		inner join paciente_tem_segurosaude pacseg on pacseg.seguroSaude_idSeguroSaude = seg.idSeguroSaude
			group by seg.tipoSeguro
				order by count(pacseg.paciente_rg) desc;
                
create view relatorioBalancoRecOp as
	select prof.nome "Gerente Responsável",
	prof.cpf "Mátricula",
	count(bal.idbalanco) "Balanços com Receita maior que Folha Pagamento"
	from balanco bal
		inner join gerente ger on ger.profissional_cpf = bal.gerente_profissional_cpf
        inner join profissional prof on prof.cpf = ger.profissional_cpf
			where bal.receita > bal.folhaPag
				group by prof.cpf
					order by count(bal.idbalanco);
                    
create view relatorioMetPagSemPlano as
	select regfat.metodoPagamento "Método Pagamento",
	concat('R$ ', format(sum(regfat.valor), 2, 'de_DE')) "Valor por Método",
    count(pac.rg) "Número Paciente por Método"
	from registrofatura regfat
		inner join paciente pac on pac.rg = regfat.paciente_rg
			where regfat.planoSaude like 'N'
				group by regfat.metodoPagamento
					order by sum(regfat.valor) desc, count(pac.rg) desc;
            