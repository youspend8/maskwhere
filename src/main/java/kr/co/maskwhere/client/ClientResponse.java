package kr.co.maskwhere.client;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import com.fasterxml.jackson.databind.ObjectMapper;

public class ClientResponse {
	public static ClientRequest fetch(ClientRequest request) throws IOException {
		URL url = new URL(request.getRequestURL());
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();

		BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));

		String line;
		StringBuilder sb = new StringBuilder();

		while ((line = br.readLine()) != null) {
			sb.append(line);
		}
		
		String result = sb.toString();
		
		request.setReponseJson(new ObjectMapper().readTree(result));
		request.setResponse(result);
		
		br.close();

		System.out.println("ClientResponse Result :: " + result);
		System.out.println("ClientResponse ResponseJson :: " + request.getReponseJson());
		System.out.println("ClientResponse Response :: " + request.getResponse());
		
		return request;
	}
}
