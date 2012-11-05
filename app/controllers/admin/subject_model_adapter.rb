class Admin::SubjectModelAdapter
  attr_accessor :subject_model
  
  def initialize(subject_model)
    @subject_model = subject_model
  end
  
  def guest?
    !subject_model
  end
  
  def logged_in?
    !!subject_model
  end
  
  def owner?(object)
    object && ( object.respond_to?(:author) && ( subject_model == object.author ) ) ||  ( object.respond_to?(:owner) && ( subject_model == object.owner ) )
  end
  alias :own? :owner?
  
  def administrator?
    true
  end
  
  def can?(*args)
    true
  end
  
  def can_edit?(*args)
    true
  end
  
  def can_create?(*args)
    true
  end
  
  def can_destroy?(*args)
    true
  end
  
  def can_new?(*args)
    true
  end
  
  def can_update?(*args)
    true
  end

  def can_sort?(*args)
    true
  end
  
  def can_show?(*args)
    true
  end
  
end
