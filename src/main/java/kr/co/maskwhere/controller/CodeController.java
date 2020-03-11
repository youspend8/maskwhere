package kr.co.maskwhere.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;

import kr.co.maskwhere.service.CodeService;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping(value="/code")
@RequiredArgsConstructor
public class CodeController {
	
	private final CodeService codeService;
	
	@GetMapping(value="/")
	public String index() {
		
		return "/index";
	}
	
	@GetMapping(value="/list")
	@ResponseBody
	public String search(Model model,
			@RequestParam(value="type", required=false) int type,
			@RequestParam(value="code", defaultValue="0") int code) throws JsonProcessingException {
		
		return codeService.get(type, code).toString();
	}
}
