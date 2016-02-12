package es.uam.eps.tfg.grammar.cup.utils;

public class CustomToken {

	String token;
	String lexema;

	public CustomToken(String lexema, String token) {
		this.lexema = lexema;
		this.token = token;
	}

	public String getToken() {
		return token;
	}

	public String getLexema() {
		return lexema;
	}

	@Override
	public String toString() {
		return "Lexema: " + lexema + " Token: " + token;
	}

}
