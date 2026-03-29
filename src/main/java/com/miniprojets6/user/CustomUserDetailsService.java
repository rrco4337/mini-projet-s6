package com.miniprojets6.user;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collections;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private static final Logger logger = LoggerFactory.getLogger(CustomUserDetailsService.class);

    private final UserRepository userRepository;

    public CustomUserDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        logger.debug("Loading user by username: {}", username);

        User user = userRepository.findByUsernameAndActifTrue(username)
                .orElseThrow(() -> {
                    logger.error("User not found or inactive: {}", username);
                    return new UsernameNotFoundException("Utilisateur non trouve: " + username);
                });

        logger.debug("User found: {}, role: {}, hash: {}",
                user.getUsername(), user.getRole(),
                user.getPasswordHash() != null ? "***PRESENT***" : "***NULL***");

        String role = "ROLE_" + user.getRole().name().toUpperCase();
        logger.debug("Granted authority: {}", role);

        return new org.springframework.security.core.userdetails.User(
                user.getUsername(),
                user.getPasswordHash(),
                Collections.singletonList(new SimpleGrantedAuthority(role))
        );
    }
}
