module RedmineCheckDueDate
  module IssuePatch
    def self.included(base)
      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)

      base.class_eval do
        before_save :check_due_date
      end
    end
  end

  module ClassMethods
  end

  module InstanceMethods
    def check_due_date
	if (!self.due_date.nil? and self.due_date < Date.today and !self.status.is_closed?)
	    self.errors.add(:due_date, "не может быть раньше текущей даты")
	    false
	else
	    self.due_date = Date.today + 1.day
	end
    end
  end
end
