<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "servlets.ConexaoBD"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.util.*"%>

<!-- Altere os endereços (url para o HTTP Request) nas linhas 99 e 124 de acordo com a localização do servidor-->


<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<img src = "banner_ime_site.jpg" height = "50%"/> <br>
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
						PreparedStatement statement = conexaoBD.connection.prepareStatement(sql,ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_READ_ONLY);
						statement.setInt(1, Integer.parseInt(dia));
						statement.setInt(2,Integer.parseInt(mes));
						statement.setInt(3,Integer.parseInt(ano));
						statement.setInt(4,Integer.parseInt(tempo));
						String data = dia+"/"+mes+"/"+ano;
						ResultSet resultSet = statement.executeQuery();
						resultSet.next();
						String cod_materia = resultSet.getString("cod_disciplina");
						resultSet.previous();
						out.println("<table width = '50%' cellspacing = '10'><tr><td rowspan ='2' align= 'center'><img src='ime.png' width= '90px'/></td><td bgcolor = '4682B4' colspan = '2' align = 'center'>"+request.getParameter("Materia")+" -"+cod_materia+"</td></tr><tr><td bgcolor = '4682B4' colspan = '2' align = 'center'>Data: "+data+" - "+tempo+"º Tempo"+"</td><td></td><td></td></tr></table>");
						out.println("<table width = '50%'border = '1' bgcolor = '4682B4'><tr><th>Matrícula</th><th>Posto</th><th>Nome</th><th>Presença</th><th>Editar</th></tr>");
						List<String> lista = new ArrayList<String>();
						int i=0;
						while (resultSet.next()){
							String matricula = resultSet.getString("matricula");
							String posto = resultSet.getString("posto");
							String nome = resultSet.getString("nome");
							Boolean presente = resultSet.getBoolean("presente");
							lista.add(resultSet.getString("cod_papeleta"));
							if(presente){
								out.println("<tr bgcolor = 'D3D3D3'>"+"<td align = center >"+matricula+"</td>"+"<td align = center>"+posto+"</td>"+"<td align = center>"+nome+"</td>"+"<td align = center id = 'celula"+i+"' bgcolor = 'GREEN'></td><td align = 'center'><input type = 'button' id = 'botao"+i+"' onclick = 'atribuirFalta("+i+")' value = 'Atribuir Falta'></td><td style = 'display: none;'><input type = 'hidden' id = 'codigo"+i+"' value = '"+lista.get(i).toString()+"'></tr>");
							} else{
								out.println("<tr bgcolor = 'wheat'>"+"<td align = center >"+matricula+"</td>"+"<td align = center>"+posto+"</td>"+"<td align = center>"+nome+"</td>"+"<td align = center id = 'celula"+i+"' bgcolor = 'RED'></td><td align = 'center'><input type = 'button' id = 'botao"+i+"' onclick = 'atribuirPresenca("+i+")' value = 'Atribuir Presença'></td><td style = 'display: none;'><input type = 'hidden' id = 'codigo"+i+"' value = '"+lista.get(i).toString()+"'></tr>");
							}
							i++;
						}
						out.println("</table><br><br>");
						out.println("<table><tr><td><strong>Legenda :</strong></td></tr><tr><td align = center bgcolor = 'GREEN'></td><td>O aluno estava presente na aula</td></tr><tr><td align = center bgcolor = 'RED'></td><td>O aluno faltou a aula</td></tr>");
						resultSet.close();
						statement.close();
						conexaoBD.close();
				} catch (SQLException erro) {
					out.println("Erro na consulta");
				}
		} else {
			out.println("Parametro não recebido ou falha de conexão");
			if(request.getParameter("botao")!=null){
				out.println("<p>"+request.getParameter("botao")+"</p>");
			}
		}
		%>
	<br>
	<div id = "saida"></div><br>
	<div id = "teste"></div>

	<br>
	<br>
	
</body>
<script type="text/javascript">
	var http = new XMLHttpRequest();
	function atribuirPresenca(id){
		 var params = "param1="+document.getElementById("codigo"+id).value; // probably use document.getElementById(...).value
		 http.onreadystatechange = function(){
			 if(http.readyState == 4 && http.status == 200){
				 document.getElementById("saida").innerHTML = http.responseText;
			 }else{
				 document.getElementById("saida").innerHTML = "<strong>Esperando resposta do servidor</strong>";
			 }
			 if(http.responseText == "Erro na consulta"){
				 document.getElementById("saida").innerHTML = http.responseText;
			 }else{
				 document.getElementById("saida").innerHTML = http.responseText;
				 document.getElementById("botao"+id).style.backgroundColor = "RED";
				 document.getElementById("celula"+id).style.backgroundColor = "RED";
			 }
		 }
		 http.open("POST", "http://localhost:8080/TchauPapeletasWeb/Update.jsp", true);
		 http.setRequestHeader("Content-type","application/x-www-form-urlencoded");//o formato application/x-www-form-urlencoded tem a forma de envio GET param1=valor, etc. A outra opção é text/plain para texto comun
		 http.send(params);
	}
	
	function atribuirFalta(id){
		 var params = "param2="+document.getElementById("codigo"+id).value;
		 http.onreadystatechange = function(){
			 if(http.readyState == 4 && http.status == 200){
				 document.getElementById("saida").innerHTML = http.responseText;
			 }else{
				 document.getElementById("saida").innerHTML = "<strong>Esperando resposta do servidor</strong>";
			 }
			 if(http.responseText == "Erro na consulta"){
				 document.getElementById("saida").innerHTML = http.responseText;
			 }else{
				 document.getElementById("saida").innerHTML = http.responseText;
				 document.getElementById("botao"+id).style.backgroundColor = "RED";
				 document.getElementById("celula"+id).style.backgroundColor = "RED";
			 }
			 
		 }
		 http.open("POST", "http://localhost:8080/TchauPapeletasWeb/Updatefalta.jsp" , true);
		 http.setRequestHeader("Content-type","application/x-www-form-urlencoded");
		 http.send(params);
	}
</script>
</html>