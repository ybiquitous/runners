Smoke = Runners::Testing::Smoke

Smoke.add_test(
  "sandbox_rails",
  guid: "test-guid",
  timestamp: :_,
  type: "success",
  issues: [
    {
      path: "db/schema.rb",
      location: { start_line: 25, start_column: 0, end_line: 25, end_column: 0 },
      id: "RailsBestPractices::Reviews::AlwaysAddDbIndexReview",
      message: "always add db index (users => [group_id])",
      links: %w[https://rails-bestpractices.com/posts/2010/07/24/always-add-db-index/],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "app/models/user.rb",
      location: { start_line: 3, start_column: 0, end_line: 3, end_column: 0 },
      id: "RailsBestPractices::Reviews::DefaultScopeIsEvilReview",
      message: "default_scope is evil",
      links: %w[https://rails-bestpractices.com/posts/2013/06/15/default_scope-is-evil/],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "app/helpers/users_helper.rb",
      location: { start_line: 1, start_column: 0, end_line: 1, end_column: 0 },
      id: "RailsBestPractices::Reviews::RemoveEmptyHelpersReview",
      message: "remove empty helpers",
      links: %w[https://rails-bestpractices.com/posts/2011/04/09/remove-empty-helpers/],
      object: nil,
      git_blame_info: nil
    },
    {
      path: "config/routes.rb",
      location: { start_line: 3, start_column: 0, end_line: 3, end_column: 0 },
      id: "RailsBestPractices::Reviews::RestrictAutoGeneratedRoutesReview",
      message: "restrict auto-generated routes users (except: [:new, :create])",
      links: %w[https://rails-bestpractices.com/posts/2011/08/19/restrict-auto-generated-routes/],
      object: nil,
      git_blame_info: nil
    }
  ],
  analyzer: { name: "rails_best_practices", version: "1.19.4" }
)

Smoke.add_test(
  "broken_sideci_yml",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "failure",
    analyzer: nil,
    message: "The value of the attribute `$.linter.rails_best_practices.exclude` of `sideci.yml` is invalid."
  }
)

Smoke.add_test(
  "valid_sideci_yml",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    analyzer: { name: "rails_best_practices", version: "1.19.4" },
    issues: [
      {
        message: "Don't rescue Exception",
        links: %w[https://rails-bestpractices.com/posts/2012/11/01/don-t-rescue-exception-rescue-standarderror/],
        id: "RailsBestPractices::Reviews::NotRescueExceptionReview",
        path: "a.rb",
        location: { start_line: 5, start_column: 0, end_line: 5, end_column: 0 },
        object: nil,
        git_blame_info: nil
      }
    ]
  },
  {
    warnings: [
      {
        message: <<~MSG
    DEPRECATION WARNING!!!
    The `$.linter.rails_best_practices.options` option(s) in your `sideci.yml` are deprecated and will be removed in the near future.
    Please update to the new option(s) according to our documentation (see https://help.sider.review/tools/ruby/rails-bestpractices ).
  MSG
          .strip,
        file: "sideci.yml"
      }
    ]
  }
)

Smoke.add_test(
  "template_engine",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    analyzer: { name: "rails_best_practices", version: "1.19.1" },
    issues: [
      {
        message: "simplify render in views",
        links: %w[https://rails-bestpractices.com/posts/2010/12/04/simplify-render-in-views/],
        id: "RailsBestPractices::Reviews::SimplifyRenderInViewsReview",
        path: "app/views/index.html.erb",
        location: { start_line: 2, start_column: 0, end_line: 2, end_column: 0 },
        object: nil,
        git_blame_info: nil
      },
      {
        message: "simplify render in views",
        links: %w[https://rails-bestpractices.com/posts/2010/12/04/simplify-render-in-views/],
        id: "RailsBestPractices::Reviews::SimplifyRenderInViewsReview",
        path: "app/views/index.html.haml",
        location: { start_line: 2, start_column: 0, end_line: 2, end_column: 0 },
        object: nil,
        git_blame_info: nil
      },
      {
        message: "simplify render in views",
        links: %w[https://rails-bestpractices.com/posts/2010/12/04/simplify-render-in-views/],
        id: "RailsBestPractices::Reviews::SimplifyRenderInViewsReview",
        path: "app/views/index.html.slim",
        location: { start_line: 2, start_column: 0, end_line: 2, end_column: 0 },
        object: nil,
        git_blame_info: nil
      }
    ]
  }
)

Smoke.add_test(
  "lowest_deps",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    analyzer: { name: "rails_best_practices", version: "1.19.1" },
    issues: [
      {
        message: "Don't rescue Exception",
        links: %w[https://rails-bestpractices.com/posts/2012/11/01/don-t-rescue-exception-rescue-standarderror/],
        id: "RailsBestPractices::Reviews::NotRescueExceptionReview",
        path: "app/models/box.rb",
        location: { start_line: 5, start_column: 0, end_line: 5, end_column: 0 },
        object: nil,
        git_blame_info: nil
      }
    ]
  }
)

Smoke.add_test(
  "slim_with_sass",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    analyzer: { name: "rails_best_practices", version: "1.19.1" },
    issues: [
      {
        message: "simplify render in views",
        links: %w[https://rails-bestpractices.com/posts/2010/12/04/simplify-render-in-views/],
        id: "RailsBestPractices::Reviews::SimplifyRenderInViewsReview",
        path: "app/views/index.html.slim",
        location: { start_line: 2, start_column: 0, end_line: 2, end_column: 0 },
        object: nil,
        git_blame_info: nil
      },
      {
        message: "simplify render in views",
        links: %w[https://rails-bestpractices.com/posts/2010/12/04/simplify-render-in-views/],
        id: "RailsBestPractices::Reviews::SimplifyRenderInViewsReview",
        path: "app/views/show.html.slim",
        location: { start_line: 2, start_column: 0, end_line: 2, end_column: 0 },
        object: nil,
        git_blame_info: nil
      }
    ]
  }
)

Smoke.add_test(
  "sassc_v1",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    analyzer: { name: "rails_best_practices", version: "1.19.1" },
    issues: [
      {
        message: "simplify render in views",
        links: %w[https://rails-bestpractices.com/posts/2010/12/04/simplify-render-in-views/],
        id: "RailsBestPractices::Reviews::SimplifyRenderInViewsReview",
        path: "app/views/index.html.slim",
        location: { start_line: 2, start_column: 0, end_line: 2, end_column: 0 },
        object: nil,
        git_blame_info: nil
      }
    ]
  }
)

Smoke.add_test(
  "unsupported",
  {
    guid: "test-guid",
    timestamp: :_,
    type: "success",
    analyzer: { name: "rails_best_practices", version: "1.19.4" },
    issues: [
      {
        message: "Don't rescue Exception",
        links: %w[https://rails-bestpractices.com/posts/2012/11/01/don-t-rescue-exception-rescue-standarderror/],
        id: "RailsBestPractices::Reviews::NotRescueExceptionReview",
        path: "app/models/box.rb",
        location: { start_line: 5, start_column: 0, end_line: 5, end_column: 0 },
        object: nil,
        git_blame_info: nil
      }
    ]
  },
  warnings: [
    {
      message: <<~MESSAGE,
    Sider tried to install `rails_best_practices 1.16.0` according to your `Gemfile.lock`, but it installs `1.19.4` instead.
    Because `1.16.0` does not satisfy the Sider constraints [">= 1.19.1", "< 2.0"].

    If you want to use a different version of `rails_best_practices`, update your `Gemfile.lock` to satisfy the constraint or specify the gem version in your `sider.yml`.
    See https://help.sider.review/getting-started/custom-configuration#gems-option
  MESSAGE
      file: nil
    }
  ]
)
