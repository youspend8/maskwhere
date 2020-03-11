package kr.co.maskwhere.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import kr.co.maskwhere.entity.CodeVO;

@Repository
public interface CodeRepository extends JpaRepository<CodeVO, String> {
	public List<CodeVO> findByType(int type);
	public List<CodeVO> findByTypeAndRegion(int type, int region);
	public List<CodeVO> findByTypeAndSigungu(int type, int sigungu);
	public List<CodeVO> findByTypeAndUmd(int type, int umd);
}
