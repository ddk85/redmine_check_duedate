require 'redmine'

ActionDispatch::Callbacks.to_prepare do
  require_dependency 'issue'
  # Guards against including the module multiple time (like in tests)
  # and registering multiple callbacks
  unless Issue.included_modules.include? RedmineCheckDueDate::IssuePatch
    Issue.send(:include, RedmineCheckDueDate::IssuePatch)
  end
end

Redmine::Plugin.register :redmine_check_due_date do
  name 'Redmine check due_date'
  author 'Dmitry Kuznetsov'
  description 'Check due_date field if issue open and due_date < today you cannot save issue'
  version '0.0.1'
  url 'https://github.com/ddk85/redmine_check_duedate'
  author_url 'https://github.com/ddk85/redmine_check_duedate'
end
