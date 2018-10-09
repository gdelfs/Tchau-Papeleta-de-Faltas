package servlets;
import java.sql.*;
import javax.swing.JOptionPane;
public class ConexaoBD{
	public Connection connection = null;
	private final String DRIVER = "org.postgresql.Driver";
	private final String DBNAME = "tchau_papeleta";
	private final String URL = "jdbc:postgresql://localhost:5432/"+DBNAME;
	private final String LOGIN = "postgres";
	private final String SENHA = "123456";
	/**
	* metodo que faz conexao com o banco de dados retorna true se houve sucesso, ou false em caso negativo
	*/
	public boolean getConnection(){
		try{
			Class.forName(DRIVER);
			connection = DriverManager.getConnection(URL, LOGIN, SENHA);
			System.out.println("Conectou");
			return true;
		} catch(ClassNotFoundException erro){
			JOptionPane.showMessageDialog(null, "Driver não encontrado!\n" + erro.toString());
			return false;
		} catch (SQLException erro){
			JOptionPane.showMessageDialog(null, "Problemas na conexão com a fonte de dados\n"+ erro.toString());
			return false;
		}
	}

	public void close(){
		try{
			connection.close();
			System.out.println("Desconectou");
		} catch (SQLException erro){}
	}
	
	public String atribuirPresenca(String codigo) {
		String sql = "update tchau_papeleta.papeleta set presente = 'true' where cod_papeleta =", saida = codigo;
		return sql+saida;
	}
}