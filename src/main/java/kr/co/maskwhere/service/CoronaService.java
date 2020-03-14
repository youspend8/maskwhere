package kr.co.maskwhere.service;

import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.JsonNodeFactory;
import com.fasterxml.jackson.databind.node.ObjectNode;

import kr.co.maskwhere.client.ClientRequest;
import kr.co.maskwhere.client.ClientResponse;

@Service
public class CoronaService {
	
	public JsonNode fetch() {
		final String url = "https://www.thereright.co.kr/api/corona/";
		final String urlDiff = "https://www.thereright.co.kr/api/corona/diff";
		final String urlRelease = "https://www.thereright.co.kr/api/corona/release";
		final String urlDied = "https://www.thereright.co.kr/api/corona/died";
		final String urlRate = "https://www.thereright.co.kr/api/corona/rate";
		final String urlNation = "https://www.thereright.co.kr/api/corona/nation";
		
		try {
			ClientRequest request = ClientRequest.builder()
					.requestURL(url)
					.build();

			ClientRequest requestDiff = ClientRequest.builder()
					.requestURL(urlDiff)
					.build();

			ClientRequest requestRelease = ClientRequest.builder()
					.requestURL(urlRelease)
					.build();

			ClientRequest requestDied = ClientRequest.builder()
					.requestURL(urlDied)
					.build();

			ClientRequest requestRate = ClientRequest.builder()
					.requestURL(urlRate)
					.build();
			
			ClientRequest requestNation = ClientRequest.builder()
					.requestURL(urlNation)
					.build();
			
			String response = ClientResponse.fetch(request).getResponse();
			String responseDiff = ClientResponse.fetch(requestDiff).getResponse();
			String responseRelease = ClientResponse.fetch(requestRelease).getResponse();
			String responseDied = ClientResponse.fetch(requestDied).getResponse();
			String responseRate = ClientResponse.fetch(requestRate).getResponse();
			String responseNation = ClientResponse.fetch(requestNation).getResponse();
			
			ObjectNode resultObj = JsonNodeFactory.instance.objectNode();
			
			JsonNode corona = this.convert(response);
			JsonNode coronaDiff = this.convert(responseDiff);
			JsonNode coronaRelease = this.convert(responseRelease);
			JsonNode coronaDied = this.convert(responseDied);
			JsonNode coronaRate = this.convert(responseRate);
			JsonNode coronaNation = this.convert(responseNation);

			resultObj.set("corona", corona);
			resultObj.set("coronaDiff", coronaDiff);
			resultObj.set("coronaRelease", coronaRelease);
			resultObj.set("coronaDied", coronaDied);
			resultObj.set("coronaRate", coronaRate);
			resultObj.set("coronaNation", coronaNation);
			
			return resultObj;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public JsonNode convert(String response) throws JsonMappingException, JsonProcessingException {
		return new ObjectMapper().readTree(response);
	}
}
