package kr.co.maskwhere.service;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONObject;
import org.springframework.stereotype.Service;

import kr.co.maskwhere.entity.CodeVO;
import kr.co.maskwhere.repository.CodeRepository;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CodeService {
	private final CodeRepository codeRepository;
	
	public JSONObject get(int type, int code) {
		List<CodeVO> list = new ArrayList<>();

		JSONObject obj = new JSONObject();
		if (type == -1) {
			list = codeRepository.findByTypeAndUmd(type + 1, code);
			obj.put("type", 0);
		} else if (type == 0) {
			list = codeRepository.findByType(type);
			obj.put("type", 0);
		} else if (type == 1) {
			list = codeRepository.findByTypeAndRegion(type, code);
			obj.put("type", 1);
		} else if (type == 2) {
		}
		
		obj.put("list", list);
		
		return obj;
	}
}
