<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "servlets.ConexaoBD"%>
<%@ page import = "java.sql.*"%>

<%

ConexaoBD conexaoBD = new ConexaoBD();
if(conexaoBD.getConnection()){ 
	//out.println("chegou no update");
	//out.println(request.getParameter("param1"));
	String sql = "update tchau_papeleta.papeleta set presente = ? where cod_papeleta ='"+(String)request.getParameter("param1")+"'" ; 
		try {
				PreparedStatement statement = conexaoBD.connection.prepareStatement(sql);
				statement.setBoolean(1, true);
				if(statement.executeUpdate() ==0){
					out.println("<strong>Houve uma falha na Operação</strong>");
				}
				out.println("<strong>Prenseça atribuida com sucesso!</strong>");
				statement.close();
				conexaoBD.close();
		}catch (SQLException erro) {
			out.println("Erro na consulta");
			conexaoBD.close();
		}
}








%>