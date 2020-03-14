package kr.co.maskwhere.client;

import com.fasterxml.jackson.databind.JsonNode;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Builder
public class ClientRequest {
	private int responseCode;
	private String requestURL;
	private String response;
	private JsonNode reponseJson;
}
