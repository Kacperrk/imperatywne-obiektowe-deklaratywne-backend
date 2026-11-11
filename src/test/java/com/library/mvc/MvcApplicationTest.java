package com.library.mvc;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Import;

@Import(TestcontainersConfiguration.class)
@SpringBootTest
class MvcApplicationTest {

  @Test
  void contextLoads() {
    // Smoke test: fails if the Spring context cannot start.
  }
}
