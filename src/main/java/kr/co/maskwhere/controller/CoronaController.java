package kr.co.maskwhere.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.JsonNode;

import kr.co.maskwhere.service.CoronaService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping(value="/corona")
@RequiredArgsConstructor
public class CoronaController {
	
	private final CoronaService coronaService;
	
	@GetMapping(value="/")
	public String index() {
		
		return "/corona";
	}
	
	@GetMapping(value="/data")
	@ResponseBody public JsonNode data() {
		
		return coronaService.fetch();
	}
}
