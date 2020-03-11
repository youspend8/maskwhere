package kr.co.maskwhere.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Entity
@Table(name="CITY_CODE")
@Getter
@Setter
@ToString
public class CodeVO {
	@Id
	@Column(name="COD_ID")
	private String id;
	
	@Column(name="CD_TYPE")
	private Integer type;
	
	@Column(name="CD_NAME")
	private String name;
	
	@Column(name="REGION_CD")
	private Integer region;
	
	@Column(name="SIGUNGU_CD")
	private Integer sigungu;
	
	@Column(name="UMD_CD")
	private Integer umd;
	
	@Column(name="FULLNAME")
	private String fullname;
}
