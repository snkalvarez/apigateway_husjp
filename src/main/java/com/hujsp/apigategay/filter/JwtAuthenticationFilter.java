package com.hujsp.apigategay.filter;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import jakarta.annotation.PostConstruct;
import org.apache.http.HttpHeaders;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.util.List;

@Component
public class JwtAuthenticationFilter implements GlobalFilter, Ordered {

    @Value("${security.jwt.key.private}")
    private String secretoJwt;

    private Algorithm algorithm;

    @PostConstruct
    public void init() {
        this.algorithm = Algorithm.HMAC256(this.secretoJwt);
    }

    List<String> excludedPaths = List.of(
            "/auth/login",
            "/auth/refresh",
            "/auth/test",
            "/auth/logout"
    );

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        String path = exchange.getRequest().getURI().getPath();

        // permitir libremente el login y el refresh token
        boolean isExcludedPath = excludedPaths.stream().anyMatch(path::contains);
        if (isExcludedPath) {
            return chain.filter(exchange);
        }
        // Permitir libremente si la cabecera X-Public-Route está en true
        String publicHeader = exchange.getRequest().getHeaders().getFirst("X-Public-Route");
        if(publicHeader != null && publicHeader.equalsIgnoreCase("true")){
            return chain.filter(exchange);
        }

        String authHeader = exchange.getRequest().getHeaders().getFirst(HttpHeaders.AUTHORIZATION);
        if(authHeader == null || !authHeader.startsWith("Bearer ")){
            exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
            return exchange.getResponse().setComplete();
        }

        String token = authHeader.substring(7);

        try{
            JWT.require(algorithm).build().verify(token);
            return chain.filter(exchange);
        } catch (Exception e) {
            exchange.getResponse().setStatusCode(HttpStatus.UNAUTHORIZED);
            return exchange.getResponse().setComplete();
        }
    }

    @Override
    public int getOrder() {
        return -1; // Prioridad alta
    }
}
