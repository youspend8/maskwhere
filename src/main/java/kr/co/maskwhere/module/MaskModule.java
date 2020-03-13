package kr.co.maskwhere.module;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Component
public class MaskModule {
	@Value("${mask.request.url}")
	private String maskUrl;
	
	private final String MASK_COORDS_URL = "https://8oi9s0nnth.apigw.ntruss.com/corona19-masks/v1/storesByGeo/json?";
	
	public Map<String, Object> fetchByCoords(Map<String, Object> params) {
		BufferedReader br = null;
		
		try {
			StringBuilder urlBuilder = new StringBuilder();
			urlBuilder.append(MASK_COORDS_URL);
			
			if (params.containsKey("lat")) {
				urlBuilder.append("lat=" + Float.parseFloat((String) params.get("lat")));
				urlBuilder.append("&");
				urlBuilder.append("lng=" + Float.parseFloat((String) params.get("lng")));
				urlBuilder.append("&");
				urlBuilder.append("m=" + 1000);
			}
			
			System.out.println("requestUrl :: " + urlBuilder.toString());
			
			URL url = new URL(urlBuilder.toString());
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			
			br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			
			StringBuilder sb = new StringBuilder();
			String line = "";
			
			while ((line = br.readLine()) != null) {
				sb.append(line);
			}
			
			ObjectMapper objectMapper = new ObjectMapper();
			
			JsonNode nodes = objectMapper.readTree(sb.toString());

			Map<String, Object> resultMap = objectMapper.convertValue(nodes, new TypeReference<Map<String, Object>>() {});
			
			System.out.println(resultMap);
			
			return resultMap;
			
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				br.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return null;
	}
	public Map<String, Object> fetch(String address) {
		BufferedReader br = null;
		
		try {
			URL url = new URL(maskUrl + "?address=" + URLEncoder.encode(address, "UTF-8"));
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			
			br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			
			StringBuilder sb = new StringBuilder();
			String line = "";
			
			while ((line = br.readLine()) != null) {
				sb.append(line);
			}
			
			ObjectMapper objectMapper = new ObjectMapper();
			
			JsonNode nodes = objectMapper.readTree(sb.toString());

			Map<String, Object> resultMap = objectMapper.convertValue(nodes, new TypeReference<Map<String, Object>>() {});
			
			System.out.println(resultMap);
			
			return resultMap;
			
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				br.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return null;
	}
}
