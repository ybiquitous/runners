NodeHarness::Testing::Smoke.add_test("phpcs3/success", {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
        { path: "app.php",
          location: { :start_line => 6 },
          id: "PSR2.Files.ClosingTag.NotAllowed",
          message: "A closing tag is not permitted at the end of a PHP file",
          links: []
        }
    ],
    analyzer: {
        name: "code_sniffer",
        version: "3.4.2"
    },
})

NodeHarness::Testing::Smoke.add_test("phpcs3/specified_dir", {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
        { path: "app/app.php",
          location: { :start_line => 6 },
          id: "PSR2.Files.ClosingTag.NotAllowed",
          message: "A closing tag is not permitted at the end of a PHP file",
          links: []
        }
    ],
    analyzer: {
        name: "code_sniffer",
        version: "3.4.2"
    },
})

NodeHarness::Testing::Smoke.add_test("phpcs3/custom_argument", {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
        { path: "app.php",
          location: { :start_line => 2 },
          id: "PEAR.Commenting.FileComment.Missing",
          message: "Missing file doc comment",
          links: []
        },
        { path: "app.php",
          location: { :start_line => 8 },
          id: "Zend.Files.ClosingTag.NotAllowed",
          message: "A closing tag is not permitted at the end of a PHP file",
          links: []
        }
    ],
    analyzer: {
        name: "code_sniffer",
        version: "3.4.2"
    },
})

NodeHarness::Testing::Smoke.add_test("phpcs3/cakephp", {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    issues: [
        { path: "app.php",
          location: { :start_line => 2 },
          id: "CakePHP.Commenting.DocBlockAlignment.DocBlockMisaligned",
          message: "Doc block not aligned with code; expected indentation of 0 but found 4",
          links: []
        },
        { path: "app.php",
          location: { :start_line => 6 },
          id: "CakePHP.Commenting.DocBlockAlignment.DocBlockMisaligned",
          message: "Doc block not aligned with code; expected indentation of 0 but found 4",
          links: []
        },
        { path: "app.php",
          location: { :start_line => 13 },
          id: "CakePHP.Commenting.DocBlockAlignment.DocBlockMisaligned",
          message: "Doc block not aligned with code; expected indentation of 4 but found 8",
          links: []
        },
        { path: "app.php",
          location: { :start_line => 19 },
          id: "CakePHP.Commenting.DocBlockAlignment.DocBlockMisaligned",
          message: "Doc block not aligned with code; expected indentation of 4 but found 0",
          links: []
        },
        { path: "app.php",
          location: { :start_line => 5 },
          id: "PSR2.Namespaces.NamespaceDeclaration.BlankLineAfter",
          message: "There must be one blank line after the namespace declaration",
          links: []
        }
    ],
    analyzer: {
        name: "code_sniffer",
        version: "3.4.2"
    },
})

NodeHarness::Testing::Smoke.add_test("phpcs3/wordpress", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    { path: "app.php",
      location: { :start_line => 1 },
      id: "Squiz.Commenting.FileComment.Missing",
      message: "Missing file doc comment",
      links: []
    },
    {
      path: "app.php",
      location: { :start_line=>1 },
      id: "WordPress.Security.SafeRedirect.wp_redirect_wp_redirect",
      message: "wp_redirect() found. Using wp_safe_redirect(), along with the allowed_redirect_hosts filter if needed, can help avoid any chances of malicious redirects within code. It is also important to remember to call exit() after a redirect so that no other unwanted code is executed.",
      links: []
    }
  ],
  analyzer: {
    name: "code_sniffer",
    version: "3.4.2"
  },
})

NodeHarness::Testing::Smoke.add_test("phpcs3/symfony", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    { path: "app.php",
      location: { :start_line => 5 },
      id: "Squiz.Functions.GlobalFunction.Found",
      message: "Consider putting global function \"test\" in a static class",
      links: []
    },
    { path: "app.php",
      location: { :start_line => 14 },
      id: "Squiz.Functions.GlobalFunction.Found",
      message: "Consider putting global function \"test\" in a static class",
      links: []
    },
    { path: "app.php",
      location: { :start_line => 21 },
      id: "Squiz.Functions.GlobalFunction.Found",
      message: "Consider putting global function \"testWithCallBack\" in a static class",
      links: []
    },
    { path: "app.php",
      location: { :start_line => 4 },
      id: "Symfony.Commenting.FunctionComment.MissingReturn",
      message: "Missing @return tag in function comment",
      links: []
    }
  ],
  analyzer: {
    name: "code_sniffer",
    version: "3.4.2"
  },
})

NodeHarness::Testing::Smoke.add_test("phpcs3/with_php_version", {
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: :_,
  analyzer: {
    name: "code_sniffer",
    version: "3.4.2"
  }
})
