module RedmineCheckDueDate
  module IssuePatch
    def self.included(base)
      base.extend(ClassMethods)

      base.send(:include, InstanceMethods)

      base.class_eval do
        before_save :check_due_date
        before_save :check_due_date_closed
      end
    end
  end

  module ClassMethods
  end

  module InstanceMethods
    def check_due_date
	if (!self.due_date.nil? and self.due_date < Date.today)
	#if (!self.due_date.nil? and self.due_date < Date.today and !self.status.is_closed?)
	    if (!self.status.is_closed?)
		self.errors.add(:due_date, "не может быть раньше текущей даты")
		#self.errors.add(:base, l(:label_duedate_date))
		false
	    end
	elsif (!self.fixed_version_id.nil? and self.due_date.nil?)
	
	    new_version = Version.find(self.fixed_version_id)
	    #    rescue
	    #end 
	    if !new_version.nil? && !new_version.due_date.nil? 
	    
		if (new_version.due_date < Date.today and !self.status.is_closed?)
		    self.errors.add(:due_date, "- в выбранной версии срок завершения ранее текущей даты. Выберите корректный срок завершения или укажите другую версию.")
		    #self.errors.add(:redmine_check_duedate, l(:label_duedate_version))
		    false
		else
	    #&& self.due_date >= Date.today
#		if self.due_date.nil?
#		if params[:issue][:due_date].nil? || (params[:issue][:due_date] == '')
#	          params[:issue][:due_date] = new_version.due_date
#		else
#		    current_version = issue.fixed_version
#	            if !current_version.nil? && (current_version.id != new_version.id) &&
			#(params[:issue][:due_date] == current_version.due_date.to_s)
			#params[:issue][:due_date] = new_version.due_date
			self.due_date = new_version.due_date
#		    end
		end
	    end
#	else
	#    self.due_date = Date.today + 1.day
	    #issue = self.id
	    #Issue.find(params[:id])
	    #begin
	    #     new_version = Version.find(params[:issue][:fixed_version_id])
	    
	#end
	end
    end
    
    def check_due_date_closed
	if (self.status.is_closed? and !self.due_date.nil? and self.due_date > Date.today)
	    self.due_date = Date.today
	end
    end
    
  end

end
