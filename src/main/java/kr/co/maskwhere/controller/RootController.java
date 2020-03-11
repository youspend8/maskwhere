package kr.co.maskwhere.controller;

import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.maskwhere.module.MaskModule;
import kr.co.maskwhere.service.CodeService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping(value="/")
@RequiredArgsConstructor
public class RootController {
	
	private final MaskModule maskModule;
	
	@GetMapping(value="/")
	public String index() {
		
		return "/index";
	}
	
	@GetMapping(value="/search/{address}")
	@ResponseBody
	public String search(Model model,
			@PathVariable("address") String address) throws JsonProcessingException {
		
		System.out.println("address :: " + address);
		
		Map<String, Object> result = maskModule.fetch(address);
		
		model.addAttribute("result", result);
		
		return new ObjectMapper().writeValueAsString(result);
	}
}
