package kr.co.maskwhere.controller;

import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.maskwhere.module.MaskModule;
import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping(value="/")
@RequiredArgsConstructor
public class RootController {
	
	private final MaskModule maskModule;
	
	@GetMapping(value={
			"/",
			"/k",
			"/f",
			"/i",
	})
	public String index() {
		
		return "/index";
	}
	
	@GetMapping(value="/search")
	@ResponseBody
	public String search(Model model,
			@RequestParam Map<String, Object> params) throws JsonProcessingException {
		
		System.out.println("params :: " + params);
		
		Map<String, Object> result = maskModule.fetchByCoords(params);
		
		model.addAttribute("result", result);
		
		return new ObjectMapper().writeValueAsString(result);
	}
	
}
