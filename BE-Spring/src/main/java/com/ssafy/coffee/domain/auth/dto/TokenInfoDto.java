package com.ssafy.coffee.domain.auth.dto;

import lombok.Builder;
import lombok.Getter;
import lombok.ToString;

@ToString
@Getter
public class TokenInfoDto {
	private String refreshToken;
	private String accessToken;

	@Builder
	public TokenInfoDto(String refreshToken, String accessToken) {
		this.refreshToken = refreshToken;
		this.accessToken = accessToken;
	}

	@Builder
	public TokenInfoDto(String accessToken) {
		this.accessToken = accessToken;
	}
}
