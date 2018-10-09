<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "servlets.ConexaoBD"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<img src = "banner_ime_site.jpg" width = "100%" height = "100%"/> <br>
	<%
	
		String dia, mes, ano, tempo, turma, materia;
		dia = request.getParameter("Dia");
		mes = request.getParameter("Mes");
		ano = request.getParameter("Ano");
		tempo = request.getParameter("Tempo");
		turma = request.getParameter("Turma");
		materia = request.getParameter("Materia");
		ConexaoBD conexaoBD = new ConexaoBD();
		if(conexaoBD.getConnection()&& request.getParameter("Mes")!=null){ 
			String sql = "select a.posto, a.nome, pa.presente, pa.cod_papeleta, pa.matricula, di.cod_disciplina from tchau_papeleta.aluno a, tchau_papeleta.papeleta pa, tchau_papeleta.turma tu, tchau_papeleta.disciplina di, tchau_papeleta.aula au where a.matricula = pa.matricula and pa.cod_aula = au.cod_aula and au.cod_disciplina = di.cod_disciplina and  au.dia =? and au.mes =? and au.ano = ? and au.tempo_aula = ? and tu.nome_turma = '"+turma+"' and di.materia ='"+materia+"'"; 
				try {
						PreparedStatement statement = conexaoBD.connection.prepareStatement(sql, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
						statement.setInt(1, Integer.parseInt(dia));
						statement.setInt(2,Integer.parseInt(mes));
						statement.setInt(3,Integer.parseInt(ano));
						statement.setInt(4,Integer.parseInt(tempo));
						String data = dia+"/"+mes+"/"+ano;
						ResultSet resultSet = statement.executeQuery();
						resultSet.next();
						String cod_materia = resultSet.getString("cod_disciplina");
						resultSet.previous();
						out.println("<table width = '40%' cellspacing = '10'><tr><td rowspan ='2' align= 'center'><img src='ime.png' width= '90px'/></td><td bgcolor = '4682B4' colspan = '2' align = 'center'>"+request.getParameter("Materia")+" - "+cod_materia+"</td></tr><tr><td bgcolor = '4682B4' colspan = '2' align = 'center'>Data: "+data+" - "+tempo+"º Tempo"+"</td><td></td><td></td></tr></table>");
						out.println("<table border = '1' bgcolor = '4682B4'><tr><th>Matrícula</th><th>Posto</th><th>Nome</th><th>Presença</th></tr>");
						while (resultSet.next()){
							String matricula = resultSet.getString("matricula");
							String posto = resultSet.getString("posto");
							String nome = resultSet.getString("nome");
							Boolean presente = resultSet.getBoolean("presente");
							if(presente){
								out.println("<tr bgcolor = 'D3D3D3'>"+"<td align = center >"+matricula+"</td>"+"<td align = center>"+posto+"</td>"+"<td align = center>"+nome+"</td>"+"<td align = center bgcolor = 'GREEN'></td></tr>");
							} else{
								out.println("<tr bgcolor = 'wheat'>"+"<td align = center >"+matricula+"</td>"+"<td align = center>"+posto+"</td>"+"<td align = center>"+nome+"</td>"+"<td align = center bgcolor = 'RED'></td></tr>");
							}
						}
							out.println("</table><br><br>");
							out.println("<table><tr><td><strong>Legenda :</strong></td></tr><tr><td align = center bgcolor = 'GREEN'></td><td>O aluno estava presente na aula</td></tr><tr><td align = center bgcolor = 'RED'></td><td>O aluno faltou a aula</td></tr>");
						resultSet.close();
						statement.close();
						conexaoBD.close();
				} catch (SQLException erro) {
					out.println("Erro na consulta");
					conexaoBD.close();
				}
		} else {
			out.println("Falha de conexão");
		}
		%>

</body>
</html>